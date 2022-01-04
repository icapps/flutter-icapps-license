import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';
import '../../bin/src/service/pubdev_webservice.dart';
import '../../bin/src/service/webservice.dart';
import '../../bin/src/model/dto/dependency.dart';
import '../../bin/src/model/dto/dependency_lock.dart';
import '../../bin/src/model/exception/fatal_exception.dart';
import '../../bin/src/extension/github_extensions.dart';

void main() {
  group('Test PubDevWebService', () {
    test('test this getPubDevData with correct data', () async {
      const dependency = Dependency(
        name: 'test_package',
        version: '1.0.0',
        isDevDependency: false,
        isPartOfFlutterSdk: false,
        isGitDependency: false,
        isLocalDependency: false,
      );
      const lockedDependency = DependencyLock(
        name: 'test_package',
        source: 'pub.dev',
        version: '1.0.0',
        isDirectDevDependency: false,
        isTransitiveDependency: false,
        isDirectMainDependency: true,
      );
      final data = <String, dynamic>{
        'pubspec': {
          'name': 'test_package',
          'version': '1.0.0',
          'homepage': 'https://hompage.com',
          'repository': 'https://repository.com',
        }
      };
      final webservice = TestJsonWebService(data);
      final pubDevService = PubDevWebservice(webservice: webservice);
      final pubDevPackage = await pubDevService.getPubDevData(dependency, lockedDependency);
      expect(pubDevPackage!.pubspec.name, 'test_package');
      expect(pubDevPackage.pubspec.version, '1.0.0');
      expect(pubDevPackage.pubspec.homepage, 'https://hompage.com');
      expect(pubDevPackage.pubspec.repository, 'https://repository.com');
    });

    test('test this getPubDevData with invalid data but local repo', () async {
      final path = join(
        Directory.current.path,
        'test',
        'service',
        'pub_dev_web_service_test_data',
        'local_package',
      );
      final dependency = Dependency(
        name: 'test_package',
        version: '1.0.0',
        isDevDependency: false,
        isPartOfFlutterSdk: false,
        isGitDependency: false,
        isLocalDependency: true,
        localPath: path,
      );
      const lockedDependency = DependencyLock(
        name: 'test_package',
        source: 'pub.dev',
        version: '1.0.0',
        isDirectDevDependency: false,
        isTransitiveDependency: false,
        isDirectMainDependency: true,
      );
      final data = <String, dynamic>{};
      final webservice = TestJsonWebService(data);
      final pubDevService = PubDevWebservice(webservice: webservice);
      final pubDevPackage = await pubDevService.getPubDevData(dependency, lockedDependency);
      expect(pubDevPackage!.pubspec.name, 'test_package');
      expect(pubDevPackage.pubspec.version, '1.0.0');
      expect(pubDevPackage.pubspec.homepage, 'https://hompage.com');
      expect(pubDevPackage.pubspec.repository, 'https://repository.com');
    });

    test('test this getPubDevData with invalid data but github repo', () async {
      const dependency = Dependency(
        name: 'test_package',
        version: '1.0.0',
        isDevDependency: false,
        isPartOfFlutterSdk: false,
        isGitDependency: true,
        gitPath: GitInfo(
          url: 'git@github.com:icapps/flutter-icapps-license.git',
        ),
        isLocalDependency: false,
      );
      const lockedDependency = DependencyLock(
        name: 'test_package',
        source: 'pub.dev',
        version: '1.0.0',
        isDirectDevDependency: false,
        isTransitiveDependency: false,
        isDirectMainDependency: true,
      );
      final data = <String, dynamic>{};
      const gitData = r'''
name: license_generator
version: 3.0.0
homepage: https://homepage.com
repository: https://repository.com
''';
      final webservice = TestJsonAndGitWebService(data, gitData);
      final pubDevService = PubDevWebservice(webservice: webservice);
      final pubDevPackage = await pubDevService.getPubDevData(dependency, lockedDependency);
      expect(pubDevPackage!.pubspec.name, 'license_generator');
      expect(pubDevPackage.pubspec.version, '3.0.0');
      expect(pubDevPackage.pubspec.homepage, 'https://homepage.com');
      expect(pubDevPackage.pubspec.repository, 'https://repository.com');
    });

    test('test this getPubDevData with invalid data but git lab repo', () async {
      const dependency = Dependency(
        name: 'test_package',
        version: '1.0.0',
        isDevDependency: false,
        isPartOfFlutterSdk: false,
        isGitDependency: true,
        gitPath: GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/app/flutter-sdk.git',
        ),
        isLocalDependency: false,
      );
      const lockedDependency = DependencyLock(
        name: 'test_package',
        source: 'pub.dev',
        version: '1.0.0',
        isDirectDevDependency: false,
        isTransitiveDependency: false,
        isDirectMainDependency: true,
      );
      final data = <String, dynamic>{};
      const gitData = r'''
name: license_generator
version: 3.0.0
homepage: https://homepage.com
repository: https://repository.com
''';
      final webservice = TestJsonAndGitWebService(data, gitData);
      final pubDevService = PubDevWebservice(webservice: webservice);
      final pubDevPackage = await pubDevService.getPubDevData(dependency, lockedDependency);
      expect(pubDevPackage!.pubspec.name, 'license_generator');
      expect(pubDevPackage.pubspec.version, '3.0.0');
      expect(pubDevPackage.pubspec.homepage, 'https://homepage.com');
      expect(pubDevPackage.pubspec.repository, 'https://repository.com');
    });

    test('test this getPubDevData with unkown url', () async {
      const dependency = Dependency(
        name: 'test_package',
        version: '1.0.0',
        isDevDependency: false,
        isPartOfFlutterSdk: false,
        isGitDependency: true,
        gitPath: GitInfo(
          url: '../',
        ),
        isLocalDependency: false,
      );
      const lockedDependency = DependencyLock(
        name: 'test_package',
        source: 'pub.dev',
        version: '1.0.0',
        isDirectDevDependency: false,
        isTransitiveDependency: false,
        isDirectMainDependency: true,
      );
      final data = <String, dynamic>{};
      final webservice = TestJsonWebService(data);
      final pubDevService = PubDevWebservice(webservice: webservice);
      expect(
        () async => pubDevService.getPubDevData(dependency, lockedDependency),
        throwsA(predicate((e) =>
            e is FatalException &&
            e.message == 'This git url is not yet supported: ../. Create an issue so we can make this plugin better. (https://github.com/icapps/flutter-icapps-license/issues)')),
      );
    });
  });
}

@immutable
class TestStringWebService extends WebService {
  final String data;

  const TestStringWebService(this.data);

  @override
  Future<String> get(String url) async => data;
}

@immutable
class TestJsonWebService extends WebService {
  final Map<String, dynamic> data;

  const TestJsonWebService(this.data);

  @override
  Future<String> get(String url) async => jsonEncode(data);
}

@immutable
class TestJsonAndGitWebService extends WebService {
  final Map<String, dynamic> data;
  final String githubData;

  const TestJsonAndGitWebService(
    this.data,
    this.githubData,
  );

  @override
  Future<String> get(String url) async {
    if (url.isGithubRawUrl() || url.isGitLabUrl()) return githubData;
    return jsonEncode(data);
  }
}
