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
  static const yamlConfigExtraLicensesList = 'extra_licenses';
  static const yamlConfigExtraLicenseName = 'name';
  static const yamlConfigExtraLicenseVersion = 'version';
  static const yamlConfigExtraLicenseUrl = 'url';
  static const yamlConfigExtraLicenseLicenseUrl = 'license';
  static const yamlConfigFailFast = 'failFast';
  static const yamlConfigNullSafety = 'nullsafety';

  static const baseUrl = 'https://pub.dev/api/packages/';
  static const urlVersionPath = '/versions/';

  static var missingLicenses = false;
  static final missingLicensesList = <String>[];

  String? projectName;
  bool failFast = false;
  bool nullSafe = false;
  final dependencies = <Dependency>[];
  final devDependencies = <Dependency>[];

  Future<void> init(String pubspecContent) async {
    final config = loadYaml(pubspecContent) as YamlMap; // ignore: avoid_as
    final projectName = config['name'] as String?; // ignore: avoid_as

    if (projectName == null || projectName.isEmpty) {
      throw Exception(
          'Could not parse the pubspec.yaml, project name not found');
    }

    final icappsLicenseConfig =
        config[yamlConfigLicense] as YamlMap?; // ignore: avoid_as

    if (icappsLicenseConfig != null) {
      failFast = icappsLicenseConfig[yamlConfigFailFast] == true;
      nullSafe = icappsLicenseConfig[yamlConfigNullSafety] == true;
    }

    final dependenciesYamlList =
        config['dependencies'] as YamlMap?; // ignore: avoid_as
    if (dependenciesYamlList != null && dependenciesYamlList.isNotEmpty) {
      for (final key in dependenciesYamlList.keys) {
        final stringKey = key as String; // ignore: avoid_as
        final value = dependenciesYamlList[key] as Object; // ignore: avoid_as
        final dependency = await _getDependency(
            stringKey, value, _getOverrideLicenseUrl(icappsLicenseConfig, key));
        if (dependency != null) {
          dependencies.add(dependency);
        }
      }
    }

    final devDependenciesYamlList =
        config['dev_dependencies'] as YamlMap?; // ignore: avoid_as
    if (devDependenciesYamlList != null && devDependenciesYamlList.isNotEmpty) {
      for (final key in devDependenciesYamlList.keys) {
        final stringKey = key as String; // ignore: avoid_as
        final value =
            devDependenciesYamlList[key] as Object; // ignore: avoid_as
        final dependency = await _getDependency(
            stringKey, value, _getOverrideLicenseUrl(icappsLicenseConfig, key));
        if (dependency != null) {
          devDependencies.add(dependency);
        }
      }
    }

    if (icappsLicenseConfig == null) return;
    final extraDependenciesYamlList =
        icappsLicenseConfig[yamlConfigExtraLicensesList]
            as YamlMap?; // ignore: avoid_as
    if (extraDependenciesYamlList != null &&
        extraDependenciesYamlList.isNotEmpty) {
      for (final key in extraDependenciesYamlList.keys) {
        final stringKey = key as String; // ignore: avoid_as
        final value =
            extraDependenciesYamlList[key] as Object; // ignore: avoid_as
        final dependency = await _getExtraDependency(stringKey, value);
        if (dependency != null) {
          devDependencies.add(dependency);
        }
      }
    }
  }

  String? _getOverrideLicenseUrl(YamlMap? icappsLicenseConfig, String name) {
    if (icappsLicenseConfig == null) return null;
    final overrideLicenseMap = icappsLicenseConfig[yamlConfigLicensesList]
        as YamlMap?; // ignore: avoid_as
    if (overrideLicenseMap == null) return null;
    return overrideLicenseMap[name] as String?; // ignore: avoid_as
  }

  Future<Dependency?> _getDependency(
      String name, Object value, String? overrideLicense) async {
    if (value is YamlMap) {
      if (value.containsKey('sdk') && value['sdk'] == 'flutter') {
        print('$name is part of flutter itself.');
        print('----');
        return null;
      } else {
        missingLicensesList.add(
            'The license for $name could not be fetched automaticly. $name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
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
    final version = value;

    final apiUrl =
        baseUrl + name + urlVersionPath + version.replaceFirst('^', '');
    print('Api Url: $apiUrl');
    final result = await http.get(Uri.parse(apiUrl));
    if (result.statusCode != HttpStatus.ok) {
      missingLicensesList.add(
          '$name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
      missingLicenses = true;
      print('----');
      return null;
    }
    final jsonObj =
        json.decode(result.body) as Map<String, dynamic>; // ignore: avoid_as
    final package = Package.fromJson(jsonObj);
    String? licenseUrl;
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
    final license = await _getLicense(name, licenseUrl);
    if (license == null) return null;

    print('----');
    return Dependency(
      name: name,
      version: version,
      licenseUrl: isNetworkUrl(licenseUrl) ? licenseUrl : null,
      license: license,
      url: package.pubspec.homepage,
    );
  }

  Future<Dependency?> _getExtraDependency(
      String pubspecName, Object value) async {
    if (value is! YamlMap) {
      missingLicensesList.add(
          'Extra dependency: $pubspecName should define under extra_dependencies. Everything should be configured here');
      missingLicenses = true;
      print('----');
      return null;
    }
    final name =
        value[yamlConfigExtraLicenseName] as String?; // ignore: avoid_as
    final version =
        value[yamlConfigExtraLicenseVersion] as String?; // ignore: avoid_as
    final url = value[yamlConfigExtraLicenseUrl] as String?; // ignore: avoid_as
    final licenseUrl =
        value[yamlConfigExtraLicenseLicenseUrl] as String?; // ignore: avoid_as
    if (name == null) {
      missingLicensesList.add(
          'Extra dependency: $pubspecName should define under extra_dependencies. Everything should be configured here. `name` is missing');
      missingLicenses = true;
      print('----');
      return null;
    }
    if (licenseUrl == null) {
      missingLicensesList.add(
          'Extra dependency: $pubspecName should define under extra_dependencies. Everything should be configured here. `license` is missing');
      missingLicenses = true;
      print('----');
      return null;
    }
    final license = await _getLicense(pubspecName, licenseUrl);
    if (license == null) return null;

    print('----');
    return Dependency(
      name: name,
      version: version,
      licenseUrl: isNetworkUrl(licenseUrl) ? licenseUrl : null,
      license: license,
      url: url,
    );
  }

  Future<String?> _getLicense(String name, String licenseUrl) async {
    print('LicenseUrl: $licenseUrl');
    if (isNetworkUrl(licenseUrl)) {
      final licenseResult = await http.get(Uri.parse(licenseUrl));
      if (licenseResult.statusCode != HttpStatus.ok) {
        missingLicensesList.add(
            '$name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
        missingLicenses = true;
        print('----');
        return null;
      }
      return licenseResult.body;
    }
    final file = File(licenseUrl);
    if (!file.existsSync()) {
      missingLicensesList.add(
          'File: $file does not exists. $name should define a static license or url in the pubspec.yaml (https://pub.dev/packages/$name)');
      missingLicenses = true;
      print('----');
      return null;
    }
    return file.readAsStringSync();
  }
}

String? _getLicenseUrl(String? url) {
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

bool isNetworkUrl(String licenseUrl) =>
    licenseUrl.startsWith('http://') || licenseUrl.startsWith('https://');
