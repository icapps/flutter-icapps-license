import 'dart:io';

import 'package:yaml/yaml.dart';
import '../util/logger.dart';
import 'dto/dependency.dart';
import 'pubspec_lock.dart';

const rawGithubDomain = 'https://raw.githubusercontent.com';
const githubDomain = 'https://github.com';
const licensePath = '/master/LICENSE';
const licensePathShort = '/LICENSE';

class Params {
  static const yamlConfigLicense = 'license_generator';
  static const yamlConfigLicensesList = 'licenses';
  static const yamlConfigExtraLicensesList = 'extra_licenses';
  static const yamlConfigExtraLicenseName = 'name';
  static const yamlConfigExtraLicenseVersion = 'version';
  static const yamlConfigExtraLicenseUrl = 'url';
  static const yamlConfigExtraLicenseLicenseUrl = 'license';
  static const yamlConfigFailFast = 'failFast';
  static const yamlConfigCheckBeforeGenerate = 'checkBeforeGenerate';
  static const yamlConfigDownloadPubDevDetails = 'downloadPubDevDetails';

  final pubspecLock = PubspecLock();
  String? projectName;
  var failFast = false;
  var checkBeforGenerate = false;
  var downloadPubDevDetails = false;
  final _dependencies = <Dependency>[];
  final _dependencyOverrides = <String, String>{};

  Map<String, String> get dependencyOverrides => _dependencyOverrides;

  List<Dependency> get dependencies => _dependencies;

  List<Dependency> get devDependencies => _dependencies.where((element) => element.isDevDependency).toList();

  List<Dependency> get mainDependencies => _dependencies.where((element) => !element.isDevDependency).toList();

  Future<void> init(String pubspecContent, String pubspecLockContent) async {
    final config = loadYaml(pubspecContent) as YamlMap;
    final projectName = config['name'] as String?;

    if (projectName == null || projectName.isEmpty) {
      throw Exception('Could not parse the pubspec.yaml, project name not found');
    }

    final icappsLicenseConfig = config[yamlConfigLicense] as YamlMap?;

    if (icappsLicenseConfig != null) {
      failFast = icappsLicenseConfig[yamlConfigFailFast] == true;
      checkBeforGenerate = icappsLicenseConfig[yamlConfigCheckBeforeGenerate] == true;
      downloadPubDevDetails = icappsLicenseConfig[yamlConfigDownloadPubDevDetails] == true;
      generateLicensesOverride(icappsLicenseConfig[yamlConfigLicensesList] as YamlMap?);
    }

    final packages = config['dependencies'] as YamlMap?;
    final devPackages = config['dev_dependencies'] as YamlMap?;
    generateDependencies(packages: packages, isDevDependency: false);
    generateDependencies(packages: devPackages, isDevDependency: true);

    final containsLicenseGenerator = devDependencies.where((element) => element.name == yamlConfigLicense).isNotEmpty;
    if (!containsLicenseGenerator) {
      Logger.logInfo('$yamlConfigLicense should be added to the dev_dependencies.');
      exit(-1);
    }
    await pubspecLock.init(pubspecLockContent);
    Logger.logInfo('pubspec.yaml:');
    Logger.logInfo('All: ${dependencies.length}');
    Logger.logInfo('Main: ${mainDependencies.length}');
    Logger.logInfo('Dev: ${devDependencies.length}');
    Logger.logInfo('----');
    Logger.logInfo('pubspec.lock:');
    Logger.logInfo('All: ${pubspecLock.dependencies.length}');
    Logger.logInfo('Main: ${pubspecLock.mainDependencies.length}');
    Logger.logInfo('Dev: ${pubspecLock.devDependencies.length}');
    Logger.logInfo('Transitive: ${pubspecLock.transitiveDependencies.length}');
    Logger.logInfo('----');
  }

  void generateDependencies({required YamlMap? packages, required bool isDevDependency}) {
    final type = isDevDependency ? 'dev_dependencies' : 'dependencies';
    if (packages != null) {
      for (final package in packages.keys) {
        try {
          if (package is! String) throw ArgumentError('package should be a String, the name of the package');
          final dynamic values = packages.value[package];
          Dependency dependency;
          if (values is String) {
            dependency = Dependency.fromWithVersion(package: package, isDevDependency: isDevDependency, version: values);
          } else if (values is YamlMap) {
            dependency = Dependency.fromJson(package: package, isDevDependency: isDevDependency, data: values);
          } else {
            throw ArgumentError('${values.runtimeType} ($type) is no String or YamlMap');
          }
          _dependencies.add(dependency);
        } catch (e, trace) {
          Logger.logInfo('Failed to parse: $package for $type because of $e');
          Logger.logError('because of $e');
          Logger.logStacktrace(trace);
          rethrow;
        }
      }
    }
  }

  void generateLicensesOverride(YamlMap? packages) {
    if (packages != null) {
      for (final package in packages.keys) {
        try {
          if (package is! String) throw ArgumentError('package should be a String, the name of the package');
          final dynamic value = packages.value[package];
          if (value is String) {
            _dependencyOverrides[package] = value;
          } else {
            throw ArgumentError('${value.runtimeType} is no String');
          }
        } catch (e, trace) {
          Logger.logInfo('Failed to parse: $package because of $e');
          Logger.logError('Because of $e');
          Logger.logStacktrace(trace);
          rethrow;
        }
      }
    }
  }
}
