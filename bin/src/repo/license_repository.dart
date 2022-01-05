import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';

import '../model/dto/dependency.dart';
import '../model/dto/dependency_license_data.dart';
import '../model/dto/dependency_lock.dart';
import '../model/dto/extra_dependency.dart';
import '../model/exception/fatal_exception.dart';
import '../model/pubspec.dart';
import '../service/config_service.dart';
import '../service/pubdev_webservice.dart';
import '../service/webservice.dart';
import '../util/logger.dart';

const _flutterHomeUrl = 'https://flutter.dev/';
const _flutterRepoUrl = 'https://github.com/flutter/flutter';
const _flutterLicenseUrl =
    'https://raw.githubusercontent.com/flutter/flutter/master/LICENSE';

const _allowedLicenseFilesName = [
  'LICENSE',
  'LICENSE.md',
  'LICENSE.txt',
  'LICENSE.rst',
  'License',
  'license',
  'License.md',
  'license.md',
  'license.txt',
  'License.txt',
  'License.rst',
  'license.rst',
];

@immutable
class LicenseRepository {
  final WebService _webService;
  final ConfigService _configService;
  final PubDevWebservice _pubDevWebservice;

  const LicenseRepository(
    this._webService,
    this._configService,
    this._pubDevWebservice,
  );

  Future<DependencyLicenseData> getLicenseDataForDependency(Params params,
      Dependency dependency, DependencyLock lockedDependency) async {
    if (dependency.isPartOfFlutterSdk) return _getFlutterLicenseData();
    final licenseOverride = params.dependencyOverrides[dependency.name];
    var licenseUrl = licenseOverride;
    final pubDevData =
        await _pubDevWebservice.getPubDevData(dependency, lockedDependency);
    if (licenseOverride == null) {
      final configData =
          await _configService.getConfigData(dependency, lockedDependency);
      licenseUrl = _guessLocalLicenseFile(configData.rootUri);
      Logger.logVerbose('GET LICENSE AT ${configData.rootUri} - $licenseUrl');
    }
    if (licenseUrl == null) {
      throw FatalException(
          'Failed to get the license url for ${dependency.name}');
    }
    final licenseData = await _getLicenseDataByUrl(licenseUrl);
    return DependencyLicenseData(
      homepageUrl: pubDevData?.pubspec.homepage,
      repositoryUrl: pubDevData?.pubspec.repository,
      license: licenseData,
    );
  }

  Future<DependencyLicenseData> getLicenseDataForExtraDependency(
      ExtraDependency dependency) async {
    if (dependency.isPartOfFlutterSdk) return _getFlutterLicenseData();
    final license = await _getLicenseDataByUrl(dependency.licenseUrl);
    return DependencyLicenseData(
      homepageUrl: dependency.homepageUrl,
      repositoryUrl: dependency.repositoryUrl,
      license: license,
    );
  }

  Future<DependencyLicenseData> _getFlutterLicenseData() async {
    return DependencyLicenseData(
      homepageUrl: _flutterHomeUrl,
      repositoryUrl: _flutterRepoUrl,
      license: await _getLicenseDataByUrl(_flutterLicenseUrl),
    );
  }

  static String? _guessLocalLicenseFile(String packagePath) {
    final packageFile = Directory(packagePath);
    if (!packageFile.existsSync()) {
      throw FatalException(
          '.dart_tool/package_config.json is not up to date. `$packagePath` does not exist anymore.');
    }
    for (final fileName in _allowedLicenseFilesName) {
      final file = File(join(packagePath, fileName));
      if (file.existsSync()) return file.path;
    }
    return null;
  }

  Future<String> _getLicenseDataByUrl(String licenseUrl) async {
    if (licenseUrl.startsWith('http')) {
      return _webService.get(licenseUrl);
    }
    final file = File(licenseUrl);
    if (!file.existsSync()) {
      throw FatalException('$licenseUrl does not exists');
    }
    return file.readAsStringSync();
  }
}
