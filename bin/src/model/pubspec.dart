import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import '../util/logger.dart';
import 'dto/dependency.dart';
import 'dto/extra_dependency.dart';
import 'exception/fatal_exception.dart';
import 'pubspec_lock.dart';

final defaultFileOutputPath = join('lib', 'util', 'license.dart');
const rawGithubDomain = 'https://raw.githubusercontent.com';
const githubDomain = 'https://github.com';
const licensePath = '/master/LICENSE';
const licensePathShort = '/LICENSE';

class Params {
  static const yamlConfigLicense = 'license_generator';
  static const yamlConfigOuputPath = 'output_path';
  static const yamlConfigLicensesList = 'licenses';
  static const yamlConfigExtraLicensesList = 'extra_licenses';
  static const yamlConfigExtraLicenseName = 'name';
  static const yamlConfigExtraLicenseVersion = 'version';
  static const yamlConfigExtraLicenseUrl = 'url';
  static const yamlConfigExtraLicenseLicenseUrl = 'license';
  static const yamlConfigFailFast = 'fail_fast';
  static const yamlConfigCheckBeforeGenerate = 'check_before_generate';
  static const yamlConfigDownloadPubDevDetails = 'download_pub_dev_details';
  static const yamlConfigPubDevBaseUrl = 'pub_dev_base_url';

  late PubspecLock pubspecLock;
  String fileOutputPath = defaultFileOutputPath;
  String? projectName;
  var failFast = false;
  String? pubDevBaseUrlOverride;
  var checkBeforeGenerate = false;
  var downloadPubDevDetails = false;
  final _dependencies = <Dependency>[];
  final _dependencyOverrides = <String, String>{};
  final _extraDependencies = <ExtraDependency>[];

  Map<String, String> get dependencyOverrides => _dependencyOverrides;

  List<ExtraDependency> get extraDependencies => _extraDependencies;

  List<Dependency> get dependencies => _dependencies;

  List<Dependency> get devDependencies => _dependencies.where((element) => element.isDevDependency).toList();

  List<Dependency> get mainDependencies => _dependencies.where((element) => !element.isDevDependency).toList();

  Params(String pubspecContent, String pubspecLockContent) {
    final config = loadYaml(pubspecContent) as YamlMap;
    final projectName = config['name'] as String?;

    if (projectName == null || projectName.isEmpty) {
      throw FatalException('Could not parse the pubspec.yaml, project name not found');
    }

    final icappsLicenseConfig = config[yamlConfigLicense] as YamlMap?;

    if (icappsLicenseConfig != null) {
      failFast = icappsLicenseConfig[yamlConfigFailFast] == true;
      checkBeforeGenerate = icappsLicenseConfig[yamlConfigCheckBeforeGenerate] == true;
      downloadPubDevDetails = icappsLicenseConfig[yamlConfigDownloadPubDevDetails] == true;
      pubDevBaseUrlOverride = icappsLicenseConfig[yamlConfigPubDevBaseUrl] as String?;
      fileOutputPath = (icappsLicenseConfig[yamlConfigOuputPath] as String?) ?? defaultFileOutputPath;

      _generateLicensesOverride(icappsLicenseConfig[yamlConfigLicensesList] as YamlMap?);
      _generateExtraLicenses(icappsLicenseConfig[yamlConfigExtraLicensesList] as YamlMap?);
    }

    final packages = config['dependencies'] as YamlMap?;
    final devPackages = config['dev_dependencies'] as YamlMap?;
    _generateDependencies(packages: packages, isDevDependency: false);
    _generateDependencies(packages: devPackages, isDevDependency: true);

    final containsLicenseGenerator = devDependencies.where((element) => element.name == yamlConfigLicense).isNotEmpty;
    if (!containsLicenseGenerator) {
      const message = '$yamlConfigLicense should be added to the dev_dependencies.';
      Logger.logInfo(message);
      throw FatalException(message);
    }
    pubspecLock = PubspecLock(pubspecLockContent);
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

  void _generateDependencies({required YamlMap? packages, required bool isDevDependency}) {
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
            throw FatalException('${values.runtimeType} ($type) is no String or YamlMap');
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

  void _generateLicensesOverride(YamlMap? packages) {
    if (packages != null) {
      for (final package in packages.keys) {
        try {
          if (package is! String) throw ArgumentError('package should be a String, the name of the package');
          final dynamic value = packages.value[package];
          if (value is String) {
            _dependencyOverrides[package] = value;
          } else {
            throw FatalException('${value.runtimeType} is no String');
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

  void _generateExtraLicenses(YamlMap? packages) {
    if (packages != null) {
      for (final package in packages.keys) {
        try {
          if (package is! String) throw ArgumentError('package should be a String, the name of the package');
          final dynamic value = packages.value[package];
          if (value is YamlMap) {
            _extraDependencies.add(ExtraDependency.fromJson(package, value));
          } else {
            throw FatalException('${value.runtimeType} is no YamlMap');
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
