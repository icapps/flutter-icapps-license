import 'dart:io';

import 'package:path/path.dart';
import 'package:test/test.dart';
import '../../bin/src/repo/license_repository.dart';
import '../../bin/src/model/dto/dependency.dart';
import '../../bin/src/model/dto/dependency_lock.dart';
import '../../bin/src/model/dto/extra_dependency.dart';
import '../../bin/src/model/pubspec.dart';
import '../../bin/src/model/exception/fatal_exception.dart';
import '../../bin/src/service/config_service.dart';
import '../../bin/src/service/pubdev_webservice.dart';
import '../service/pub_dev_webservice_test.dart';

void main() {
  group('Test LicenseRepository', () {
    group('getLicenseDataForDependency', () {
      test('test LicenseRepository normal', () async {
        const name = 'normal';
        const licenseWebServiceData = '';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency();
        final result = await repo.getLicenseDataForDependency(
          params,
          dependency,
          params.getFirstLockedDependency(),
        );
        expect(dependency.name, 'test_package');
        expect(result.homepageUrl, 'https://hompage.com');
        expect(result.homepageUrl, 'https://hompage.com');
        expect(result.repositoryUrl, 'https://repository.com');
        expect(result.license,
            'this is the test_package license for 1.0.0 (normal)');
      });

      test('test LicenseRepository normal dev', () async {
        const name = 'normal-dev';
        const licenseWebServiceData = '';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency(useDev: true);
        final result = await repo.getLicenseDataForDependency(
          params,
          dependency,
          params.getFirstLockedDependency(useDev: true),
        );
        expect(dependency.name, 'test_package');
        expect(result.homepageUrl, 'https://hompage.com');
        expect(result.homepageUrl, 'https://hompage.com');
        expect(result.repositoryUrl, 'https://repository.com');
        expect(result.license,
            'this is the test_package license for 1.0.0 (normal-dev)');
      });

      test('test LicenseRepository http override', () async {
        const name = 'http-override';
        const licenseWebServiceData =
            'this is the test_package license for 1.0.0 with override http';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency();
        final result = await repo.getLicenseDataForDependency(
          params,
          dependency,
          params.getFirstLockedDependency(),
        );
        expect(dependency.name, 'test_package');
        expect(result.homepageUrl, 'https://hompage.com');
        expect(result.homepageUrl, 'https://hompage.com');
        expect(result.repositoryUrl, 'https://repository.com');
        expect(result.license,
            'this is the test_package license for 1.0.0 with override http');
      });

      test('test LicenseRepository http override dev', () async {
        const name = 'http-override-dev';
        const licenseWebServiceData =
            'this is the test_package license for 1.0.0 with override http dev';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency(useDev: true);
        final result = await repo.getLicenseDataForDependency(
          params,
          dependency,
          params.getFirstLockedDependency(useDev: true),
        );
        expect(dependency.name, 'test_package');
        expect(result.homepageUrl, 'https://hompage.com');
        expect(result.homepageUrl, 'https://hompage.com');
        expect(result.repositoryUrl, 'https://repository.com');
        expect(result.license,
            'this is the test_package license for 1.0.0 with override http dev');
      });

      test('test LicenseRepository file override ', () async {
        const name = 'file-override-not-exist';
        const licenseWebServiceData =
            'this is the test_package license for 1.0.0 with override file (not exist)';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency();
        expect(
          () async => repo.getLicenseDataForDependency(
            params,
            dependency,
            params.getFirstLockedDependency(),
          ),
          throwsA(predicate((e) =>
              e is FatalException &&
              e.message == '/test/test.md does not exists')),
        );
      });

      test('test LicenseRepository file override dev', () async {
        const name = 'file-override-not-exist-dev';
        const licenseWebServiceData =
            'this is the test_package license for 1.0.0 with override file (not exist) dev';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency(useDev: true);
        expect(
          () async => repo.getLicenseDataForDependency(
            params,
            dependency,
            params.getFirstLockedDependency(useDev: true),
          ),
          throwsA(predicate((e) =>
              e is FatalException &&
              e.message == '/test/test-dev.md does not exists')),
        );
      });

      test('test LicenseRepository no local license', () async {
        const name = 'no-local-license';
        const licenseWebServiceData = '';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency();
        expect(
          () async => repo.getLicenseDataForDependency(
            params,
            dependency,
            params.getFirstLockedDependency(),
          ),
          throwsA(predicate((e) =>
              e is FatalException &&
              e.message ==
                  '.dart_tool/package_config.json is not up to date. `test/repo/test_data/no-local-license/test_package-1.0.0-does-not-exist` does not exist anymore.')),
        );
      });
      test('test LicenseRepository no local license dev', () async {
        const name = 'no-local-license-dev';
        const licenseWebServiceData = '';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency(useDev: true);
        expect(
          () async => repo.getLicenseDataForDependency(
            params,
            dependency,
            params.getFirstLockedDependency(useDev: true),
          ),
          throwsA(predicate((e) =>
              e is FatalException &&
              e.message ==
                  '.dart_tool/package_config.json is not up to date. `test/repo/test_data/no-local-license-dev/test_package-1.0.0-does-not-exist` does not exist anymore.')),
        );
      });

      test('test LicenseRepository no local license file', () async {
        const name = 'no-local-license-file';
        const licenseWebServiceData = '';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency();
        expect(
          () async => repo.getLicenseDataForDependency(
            params,
            dependency,
            params.getFirstLockedDependency(),
          ),
          throwsA(predicate((e) =>
              e is FatalException &&
              e.message == 'Failed to get the license url for test_package')),
        );
      });

      test('test LicenseRepository no local license file dev', () async {
        const name = 'no-local-license-file-dev';
        const licenseWebServiceData = '';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency(useDev: true);
        expect(
          () async => repo.getLicenseDataForDependency(
            params,
            dependency,
            params.getFirstLockedDependency(useDev: true),
          ),
          throwsA(predicate((e) =>
              e is FatalException &&
              e.message == 'Failed to get the license url for test_package')),
        );
      });

      test('test LicenseRepository flutter-sdk', () async {
        const name = 'flutter-sdk';
        const licenseWebServiceData = 'flutter-license-via-web';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency();
        final result = await repo.getLicenseDataForDependency(
          params,
          dependency,
          params.getFirstLockedDependency(),
        );
        expect(result.license, 'flutter-license-via-web');
      });

      test('test LicenseRepository flutter-sdk-dev', () async {
        const name = 'flutter-sdk-dev';
        const licenseWebServiceData = 'flutter-license-via-web-dev';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://hompage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final params = getParams(name);
        final dependency = params.getFirstDependency(useDev: true);
        final result = await repo.getLicenseDataForDependency(
          params,
          dependency,
          params.getFirstLockedDependency(useDev: true),
        );
        expect(result.license, 'flutter-license-via-web-dev');
      });
    });
    group('getLicenseDataForExtraDependency', () {
      test('test LicenseRepository extra licenses', () async {
        const name = 'extra_licenses';
        const licenseWebServiceData = '';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://homepage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final result = await repo.getLicenseDataForExtraDependency(
          ExtraDependency(
            name: 'test_package',
            version: '1.0.0',
            licenseUrl: join(
                Directory.current.path,
                'test',
                'repo',
                'test_data',
                'extra_licenses',
                'test_package-1.0.0',
                'License.md'),
            isPartOfFlutterSdk: false,
            homepageUrl: 'https://homepage.com',
            repositoryUrl: 'https://repository.com',
            isDevDependency: false,
          ),
        );
        expect(result.homepageUrl, 'https://homepage.com');
        expect(result.repositoryUrl, 'https://repository.com');
        expect(result.license,
            'this is the test_package license for 1.0.0 (extra_licenses)');
      });
      test('test LicenseRepository extra licenses http', () async {
        const name = 'extra_licenses_http';
        const licenseWebServiceData = 'hardcoded license in test';
        final pubDevWebServiceData = <String, dynamic>{
          'pubspec': {
            'name': 'test_package',
            'version': '1.0.0',
            'homepage': 'https://homepage.com',
            'repository': 'https://repository.com',
          }
        };
        final repo =
            getLicenseRepo(name, licenseWebServiceData, pubDevWebServiceData);
        final result = await repo.getLicenseDataForExtraDependency(
          const ExtraDependency(
            name: 'test_package',
            version: '1.0.0',
            licenseUrl: 'https://test.com',
            isPartOfFlutterSdk: false,
            homepageUrl: 'https://homepage.com',
            repositoryUrl: 'https://repository.com',
            isDevDependency: false,
          ),
        );
        expect(result.homepageUrl, 'https://homepage.com');
        expect(result.repositoryUrl, 'https://repository.com');
        expect(result.license, 'hardcoded license in test');
      });
    });
  });
}

String getPath(String name) =>
    join(Directory.current.path, 'test', 'repo', 'test_data', name);

String getPackagesConfigJsonPath(String name) =>
    join(getPath(name), '$name.json');

String getPubspec(String name) {
  final path = join(getPath(name), '$name.yaml');
  final file = File(path);
  return file.readAsStringSync();
}

String getPubspecLock(String name) {
  final path = join(getPath(name), '$name.lock');
  final file = File(path);
  return file.readAsStringSync();
}

Params getParams(String name) {
  final pubspec = getPubspec(name);
  final pubspecLock = getPubspecLock(name);
  return Params(pubspec, pubspecLock);
}

LicenseRepository getLicenseRepo(String name, String licenseWebServiceData,
    Map<String, dynamic> pubDevWebServiceData) {
  final licenseWebservice = TestStringWebService(licenseWebServiceData);
  final webservice = TestJsonWebService(pubDevWebServiceData);
  final pubDevService = PubDevWebservice(webservice: webservice);
  final configService = ConfigService(path: getPackagesConfigJsonPath(name));
  return LicenseRepository(licenseWebservice, configService, pubDevService);
}

extension ParamsExtensions on Params {
  Dependency getFirstDependency({bool useDev = false}) {
    if (useDev) {
      return devDependencies.first;
    }
    return mainDependencies.first;
  }

  DependencyLock getFirstLockedDependency({bool useDev = false}) {
    List<DependencyLock> lockedDependencies;
    if (useDev) {
      lockedDependencies = pubspecLock.devDependencies;
    } else {
      lockedDependencies = pubspecLock.mainDependencies;
    }
    return lockedDependencies.firstWhere(
        (element) => element.name == getFirstDependency(useDev: useDev).name);
  }
}
