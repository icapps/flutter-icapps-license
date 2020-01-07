import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:http/http.dart' as http;
import 'model/dto/dependency.dart';

import 'model/webservice/package.dart';

class Params {
  static const yamlConfigLicense = 'icapps_license';
  static const yamlConfigLicensesList = 'licenses';
  static const yamlConfigFailFast = 'failFast';

  static const rawGithubDomain = 'https://raw.githubusercontent.com';
  static const githubDomain = 'https://github.com';

  static const baseUrl = 'https://pub.dev/api/packages/';
  static const urlVersionPath = '/versions/';
  static const licensePath = '/master/LICENSE';
  static const licensePathShort = '/LICENSE';

  static var missingLicenses = false;
  static final missingLicensesList = List<String>();

  String projectName;
  bool failFast = false;
  final dependencies = List<Dependency>();
  final devDependencies = List<Dependency>();

  Future<void> init(pubspecContent) async {
    final config = loadYaml(pubspecContent);
    projectName = config['name'];

    if (projectName == null || projectName.isEmpty) {
      throw Exception('Could not parse the pubspec.yaml, project name not found');
    }

    final YamlMap icappsLicenseConfig = config[yamlConfigLicense];

    if (icappsLicenseConfig != null) {
      failFast = icappsLicenseConfig[yamlConfigFailFast] == 'true';
    }

    final YamlMap dependenciesYamlList = config['dependencies'];
    if (dependenciesYamlList != null && dependenciesYamlList.isNotEmpty) {
      for (final key in dependenciesYamlList.keys) {
        final value = dependenciesYamlList[key];
        final dependency = await _getDependency(key, value, _getOverrideLicenseUrl(icappsLicenseConfig, key));
        if (dependency != null) {
          dependencies.add(dependency);
        }
      }
    }

    final YamlMap devDependenciesYamlList = config['dev_dependencies'];
    if (devDependenciesYamlList != null && devDependenciesYamlList.isNotEmpty) {
      for (final key in devDependenciesYamlList.keys) {
        final value = devDependenciesYamlList[key];
        final dependency = await _getDependency(key, value, _getOverrideLicenseUrl(icappsLicenseConfig, key));
        if (dependency != null) {
          devDependencies.add(dependency);
        }
      }
    }
  }

  String _getOverrideLicenseUrl(YamlMap icappsLicenseConfig, String name) {
    if (icappsLicenseConfig == null) return null;
    final YamlMap overrideLicenseMap = icappsLicenseConfig[yamlConfigLicensesList];
    return overrideLicenseMap[name];
  }

  Future<Dependency> _getDependency(String name, value, String overrideLicense) async {
    String version;
    if (value is YamlMap) {
      if (value.containsKey('sdk') && value['sdk'] == 'flutter') {
        print('$name is part of flutter itself.');
        print('----');
        return null;
      } else {
        missingLicensesList.add('$name should define a static license or url in the pubspec.yaml');
        missingLicenses = true;
        print('----');
      }
      return null;
    } else if (!(value is String)) {
      missingLicensesList.add('$name should define a static license or url in the pubspec.yaml');
      missingLicenses = true;
      print('----');
      return null;
    }
    version = value;

    final apiUrl = baseUrl + name + urlVersionPath + version.replaceFirst('^', '');
    print(apiUrl);
    final result = await http.get(apiUrl);
    if (result.statusCode != HttpStatus.ok) {
      missingLicensesList.add('$name should define a static license or url in the pubspec.yaml');
      missingLicenses = true;
      print('----');
      return null;
    }
    final jsonObj = json.decode(result.body);
    final package = Package.fromJson(jsonObj);
    String licenseUrl;
    if (overrideLicense == null) {
      if (package.pubspec.homepage.startsWith(githubDomain)) {
        var rawUrl = package.pubspec.homepage.replaceFirst(githubDomain, rawGithubDomain);
        if (rawUrl.contains('/blob/master/')) {
          rawUrl = rawUrl.replaceFirst('/blob/master/', '/master/');
          licenseUrl = rawUrl + licensePathShort;
        } else if (rawUrl.contains('/tree/master')) {
          rawUrl = rawUrl.replaceFirst('/tree/master/', '/master/');
          licenseUrl = rawUrl + licensePathShort;
        } else {
          licenseUrl = rawUrl + licensePath;
        }
      }
    } else {
      print('Overriding $name license url with: $overrideLicense');
      licenseUrl = overrideLicense;
    }
    print(licenseUrl);
    final licenseResult = await http.get(licenseUrl);
    if (licenseResult.statusCode != HttpStatus.ok) {
      missingLicensesList.add('$name should define a static license or url in the pubspec.yaml');
      missingLicenses = true;
      print('----');
      return null;
    }
    final license = licenseResult.body;
    print('----');
    return Dependency(name: name, version: version, licenseUrl: licenseUrl, license: license, url: package.pubspec.homepage);
  }
}
