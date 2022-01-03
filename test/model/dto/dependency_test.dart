import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import '../../../bin/src/model/dto/dependency.dart';
import '../../../bin/src/model/dto/dependency_lock.dart';

void main() {
  group('Test Dependency', () {
    test('Test dependency parsing', () {
      final data = <String, dynamic>{};
      final yamlMap = YamlMap.wrap(data);
      final dependency = Dependency.fromJson(
        package: 'test_package',
        isDevDependency: false,
        data: yamlMap,
      );
      expect(dependency.name, 'test_package');
      expect(dependency.isDevDependency, false);
      expect(dependency.isExtraDependency, false);
      expect(dependency.isGitDependency, false);
      expect(dependency.gitPath, null);
      expect(dependency.isLocalDependency, false);
      expect(dependency.localPath, null);
      expect(dependency.isPartOfFlutterSdk, false);
    });
    group('sdk', () {
      test('Test dependency parsing from sdk', () {
        final data = <String, dynamic>{
          'sdk': 'flutter',
        };
        final yamlMap = YamlMap.wrap(data);
        final dependency = Dependency.fromJson(
          package: 'test_package',
          isDevDependency: false,
          data: yamlMap,
        );
        expect(dependency.name, 'test_package');
        expect(dependency.isDevDependency, false);
        expect(dependency.isExtraDependency, false);
        expect(dependency.isGitDependency, false);
        expect(dependency.gitPath, null);
        expect(dependency.isLocalDependency, false);
        expect(dependency.localPath, null);
        expect(dependency.isPartOfFlutterSdk, true);
      });
      test('Test dependency parsing from sdk bla bla', () {
        final data = <String, dynamic>{
          'sdk': 'blabla',
        };
        final yamlMap = YamlMap.wrap(data);
        final dependency = Dependency.fromJson(
          package: 'test_package',
          isDevDependency: false,
          data: yamlMap,
        );
        expect(dependency.name, 'test_package');
        expect(dependency.isDevDependency, false);
        expect(dependency.isExtraDependency, false);
        expect(dependency.isGitDependency, false);
        expect(dependency.gitPath, null);
        expect(dependency.isLocalDependency, false);
        expect(dependency.localPath, null);
        expect(dependency.isPartOfFlutterSdk, false);
      });
    });

    group('path', () {
      test('Test dependency parsing from path', () {
        final data = <String, dynamic>{
          'path': '../',
        };
        final yamlMap = YamlMap.wrap(data);
        final dependency = Dependency.fromJson(
          package: 'test_package',
          isDevDependency: false,
          data: yamlMap,
        );
        expect(dependency.name, 'test_package');
        expect(dependency.isDevDependency, false);
        expect(dependency.isExtraDependency, false);
        expect(dependency.isGitDependency, false);
        expect(dependency.gitPath, null);
        expect(dependency.isLocalDependency, true);
        expect(dependency.localPath, '../');
        expect(dependency.isPartOfFlutterSdk, false);
      });
      test('Test dependency parsing from path with other path', () {
        final data = <String, dynamic>{
          'path': '~/test',
        };
        final yamlMap = YamlMap.wrap(data);
        final dependency = Dependency.fromJson(
          package: 'test_package',
          isDevDependency: false,
          data: yamlMap,
        );
        expect(dependency.name, 'test_package');
        expect(dependency.isDevDependency, false);
        expect(dependency.isExtraDependency, false);
        expect(dependency.isGitDependency, false);
        expect(dependency.gitPath, null);
        expect(dependency.isLocalDependency, true);
        expect(dependency.localPath, '~/test');
        expect(dependency.isPartOfFlutterSdk, false);
      });
    });
    group('git', () {
      test('Test dependency parsing from git', () {
        final data = <String, dynamic>{
          'git': YamlMap.wrap(
            <String, dynamic>{
              'url': 'git@test.com/repo',
            },
          )
        };
        final yamlMap = YamlMap.wrap(data);
        final dependency = Dependency.fromJson(
          package: 'test_package',
          isDevDependency: false,
          data: yamlMap,
        );
        expect(dependency.name, 'test_package');
        expect(dependency.isDevDependency, false);
        expect(dependency.isExtraDependency, false);
        expect(dependency.isGitDependency, true);
        expect(dependency.gitPath!.url, 'git@test.com/repo');
        expect(dependency.gitPath!.path, null);
        expect(dependency.gitPath!.ref, null);
        expect(dependency.isLocalDependency, false);
        expect(dependency.localPath, null);
        expect(dependency.isPartOfFlutterSdk, false);
      });
      test('Test dependency parsing from git with other git path', () {
        final data = <String, dynamic>{
          'git': YamlMap.wrap(
            <String, dynamic>{
              'url': 'git@test.com/repo',
              'path': 'extra-folder',
            },
          )
        };
        final yamlMap = YamlMap.wrap(data);
        final dependency = Dependency.fromJson(
          package: 'test_package',
          isDevDependency: false,
          data: yamlMap,
        );
        expect(dependency.name, 'test_package');
        expect(dependency.isDevDependency, false);
        expect(dependency.isExtraDependency, false);
        expect(dependency.isGitDependency, true);
        expect(dependency.gitPath!.url, 'git@test.com/repo');
        expect(dependency.gitPath!.path, 'extra-folder');
        expect(dependency.gitPath!.ref, null);
        expect(dependency.isLocalDependency, false);
        expect(dependency.localPath, null);
        expect(dependency.isPartOfFlutterSdk, false);
      });
      test('Test dependency parsing from git with other git path & ref', () {
        final data = <String, dynamic>{
          'git': YamlMap.wrap(
            <String, dynamic>{
              'url': 'git@test.com/repo',
              'ref': 'oiwefsoidafoi821',
            },
          )
        };
        final yamlMap = YamlMap.wrap(data);
        final dependency = Dependency.fromJson(
          package: 'test_package',
          isDevDependency: false,
          data: yamlMap,
        );
        expect(dependency.name, 'test_package');
        expect(dependency.isDevDependency, false);
        expect(dependency.isExtraDependency, false);
        expect(dependency.isGitDependency, true);
        expect(dependency.gitPath!.url, 'git@test.com/repo');
        expect(dependency.gitPath!.path, null);
        expect(dependency.gitPath!.ref, 'oiwefsoidafoi821');
        expect(dependency.isLocalDependency, false);
        expect(dependency.localPath, null);
        expect(dependency.isPartOfFlutterSdk, false);
      });
      test('Test dependency parsing from git with other git ref', () {
        final data = <String, dynamic>{
          'git': YamlMap.wrap(
            <String, dynamic>{
              'url': 'git@test.com/repo',
              'path': 'extra-folder',
              'ref': 'oiwefsoidafoi821',
            },
          )
        };
        final yamlMap = YamlMap.wrap(data);
        final dependency = Dependency.fromJson(
          package: 'test_package',
          isDevDependency: false,
          data: yamlMap,
        );
        expect(dependency.name, 'test_package');
        expect(dependency.isDevDependency, false);
        expect(dependency.isExtraDependency, false);
        expect(dependency.isGitDependency, true);
        expect(dependency.gitPath!.url, 'git@test.com/repo');
        expect(dependency.gitPath!.path, 'extra-folder');
        expect(dependency.gitPath!.ref, 'oiwefsoidafoi821');
        expect(dependency.isLocalDependency, false);
        expect(dependency.localPath, null);
        expect(dependency.isPartOfFlutterSdk, false);
      });
    });
    group('Test getVersion', () {
      test('normal with dependency version', () {
        const dependency = Dependency(
          name: 'test_package',
          isDevDependency: false,
          isPartOfFlutterSdk: false,
          isGitDependency: false,
          isLocalDependency: false,
          version: '1.0.0-dependency',
        );
        const lockedDependency = DependencyLock(
          name: 'test_package',
          isDirectDevDependency: false,
          version: '1.0.0-dependency-locked',
          isTransitiveDependency: false,
          source: 'pub.dev',
          isDirectMainDependency: false,
        );
        expect(dependency.getVersion(lockedDependency), '1.0.0-dependency');
      });
      test('null dependency version', () {
        const dependency = Dependency(
          name: 'test_package',
          isDevDependency: false,
          isPartOfFlutterSdk: false,
          isGitDependency: false,
          isLocalDependency: false,
          version: null,
        );
        const lockedDependency = DependencyLock(
          name: 'test_package',
          isDirectDevDependency: false,
          version: '1.0.0-dependency-locked',
          isTransitiveDependency: false,
          source: 'pub.dev',
          isDirectMainDependency: false,
        );
        expect(dependency.getVersion(lockedDependency), '1.0.0-dependency-locked');
      });
      test('normal with dependency version with flutter sdk', () {
        const dependency = Dependency(
          name: 'test_package',
          isDevDependency: false,
          isPartOfFlutterSdk: true,
          isGitDependency: false,
          isLocalDependency: false,
          version: '1.0.0-dependency',
        );
        const lockedDependency = DependencyLock(
          name: 'test_package',
          isDirectDevDependency: false,
          version: '1.0.0-dependency-locked',
          isTransitiveDependency: false,
          source: 'pub.dev',
          isDirectMainDependency: false,
        );
        expect(dependency.getVersion(lockedDependency), '1.0.0-dependency');
      });
      test('null dependency version with flutter sdk', () {
        const dependency = Dependency(
          name: 'test_package',
          isDevDependency: false,
          isPartOfFlutterSdk: true,
          isGitDependency: false,
          isLocalDependency: false,
          version: null,
        );
        const lockedDependency = DependencyLock(
          name: 'test_package',
          isDirectDevDependency: false,
          version: '1.0.0-dependency-locked',
          isTransitiveDependency: false,
          source: 'pub.dev',
          isDirectMainDependency: false,
        );
        expect(dependency.getVersion(lockedDependency), null);
      });
    });
  });
}
