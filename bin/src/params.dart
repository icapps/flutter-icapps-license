import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:http/http.dart' as http;
import 'model/dto/dependency.dart';

import 'model/webservice/package.dart';

const rawGithubDomain = 'https://raw.githubusercontent.com';
const githubDomain = 'https://github.com';
const licensePath = '/master/LICENSE';
const licensePathShort = '/LICENSE';

class Params {
  static const yamlConfigLicense = 'icapps_license';
  static const yamlConfigLicensesList = 'licenses';
  static const yamlConfigFailFast = 'failFast';
  static const yamlConfigNullSafety = 'nullsafety';

  static const baseUrl = 'https://pub.dev/api/packages/';
  static const urlVersionPath = '/versions/';

  static var missingLicenses = false;
  static final missingLicensesList = List<String>();

  String projectName;
  bool failFast = false;
  bool nullSafe = false;
  final dependencies = List<Dependency>();
  final devDependencies = List<Dependency>();

  Future<void> init(pubspecContent) async {
    final config = loadYaml(pubspecContent);
    projectName = config['name'];

    if (projectName == null || projectName.isEmpty) {
      throw Exception(
          'Could not parse the pubspec.yaml, project name not found');
    }

    final YamlMap icappsLicenseConfig = config[yamlConfigLicense];

    if (icappsLicenseConfig != null) {
      failFast = icappsLicenseConfig[yamlConfigFailFast] == true;
      nullSafe = icappsLicenseConfig[yamlConfigNullSafety] == true;
    }

    final YamlMap dependenciesYamlList = config['dependencies'];
    if (dependenciesYamlList != null && dependenciesYamlList.isNotEmpty) {
      for (final key in dependenciesYamlList.keys) {
        final value = dependenciesYamlList[key];
        final dependency = await _getDependency(
            key, value, _getOverrideLicenseUrl(icappsLicenseConfig, key));
        if (dependency != null) {
          dependencies.add(dependency);
        }
      }
    }

    final YamlMap devDependenciesYamlList = config['dev_dependencies'];
    if (devDependenciesYamlList != null && devDependenciesYamlList.isNotEmpty) {
      for (final key in devDependenciesYamlList.keys) {
        final value = devDependenciesYamlList[key];
        final dependency = await _getDependency(
            key, value, _getOverrideLicenseUrl(icappsLicenseConfig, key));
        if (dependency != null) {
          devDependencies.add(dependency);
        }
      }
    }
  }

  String _getOverrideLicenseUrl(YamlMap icappsLicenseConfig, String name) {
    if (icappsLicenseConfig == null) return null;
    final YamlMap overrideLicenseMap =
        icappsLicenseConfig[yamlConfigLicensesList];
    if (overrideLicenseMap == null) return null;
    return overrideLicenseMap[name];
  }

  Future<Dependency> _getDependency(
      String name, value, String overrideLicense) async {
    String version;
    if (value is YamlMap) {
      if (value.containsKey('sdk') && value['sdk'] == 'flutter') {
        print('$name is part of flutter itself.');
        print('----');
        return null;
      } else {
        missingLicensesList.add(
            '$name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
        missingLicenses = true;
        print('----');
      }
      return null;
    } else if (!(value is String)) {
      missingLicensesList.add(
          '$name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
      missingLicenses = true;
      print('----');
      return null;
    }
    version = value;

    final apiUrl =
        baseUrl + name + urlVersionPath + version.replaceFirst('^', '');
    print('Api Url: $apiUrl');
    final result = await http.get(apiUrl);
    if (result.statusCode != HttpStatus.ok) {
      missingLicensesList.add(
          '$name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
      missingLicenses = true;
      print('----');
      return null;
    }
    final jsonObj = json.decode(result.body);
    final package = Package.fromJson(jsonObj);
    String licenseUrl;
    if (overrideLicense == null) {
      licenseUrl = _getLicenseUrl(package.pubspec.repository);
      licenseUrl ??= _getLicenseUrl(package.pubspec.homepage);

      if (licenseUrl == null) {
        missingLicensesList.add(
            '$name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
        missingLicenses = true;
        print('----');
        return null;
      }
    } else {
      print('Overriding $name license url with: $overrideLicense');
      licenseUrl = overrideLicense;
    }
    print('LicenseUrl: $licenseUrl');
    final licenseResult = await http.get(licenseUrl);
    if (licenseResult.statusCode != HttpStatus.ok) {
      missingLicensesList.add(
          '$name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
      missingLicenses = true;
      print('----');
      return null;
    }
    final license = licenseResult.body;
    print('----');
    return Dependency(
        name: name,
        version: version,
        licenseUrl: licenseUrl,
        license: license,
        url: package.pubspec.homepage);
  }
}

String _getLicenseUrl(String url) {
  if (url == null) return null;
  if (url.startsWith(githubDomain)) {
    var rawUrl = url.replaceFirst(githubDomain, rawGithubDomain);
    if (rawUrl.contains('/blob/master/')) {
      rawUrl = rawUrl.replaceFirst('/blob/master/', '/master/');
      return rawUrl + licensePathShort;
    } else if (rawUrl.contains('/tree/master')) {
      rawUrl = rawUrl.replaceFirst('/tree/master/', '/master/');
      return rawUrl + licensePathShort;
    }
    return rawUrl + licensePath;
  }
  return null;
}
