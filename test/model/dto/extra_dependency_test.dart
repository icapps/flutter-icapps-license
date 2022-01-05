import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import '../../../bin/src/model/dto/extra_dependency.dart';

void main() {
  group('Test ExtraDependency', () {
    test('Test ExtraDependency parsing', () {
      final data = <String, dynamic>{};
      final yamlMap = YamlMap.wrap(data);
      expect(
        () async => ExtraDependency.fromJson('test_package', yamlMap),
        throwsA(predicate((e) => e.toString() == r"type 'Null' is not a subtype of type 'String' in type cast")),
      );
    });

    test('Test ExtraDependency parsing with license http', () {
      final data = <String, dynamic>{
        'license': 'https://test.com',
      };
      final yamlMap = YamlMap.wrap(data);
      final dependency = ExtraDependency.fromJson('test_package', yamlMap);
      expect(dependency.name, 'test_package');
      expect(dependency.isDevDependency, false);
      expect(dependency.isExtraDependency, false);
      expect(dependency.isGitDependency, false);
      expect(dependency.gitPath, null);
      expect(dependency.isLocalDependency, false);
      expect(dependency.localPath, null);
      expect(dependency.isPartOfFlutterSdk, false);
      expect(dependency.isPartOfFlutterSdk, false);
      expect(dependency.homepageUrl, null);
      expect(dependency.repositoryUrl, null);
      expect(dependency.licenseUrl, 'https://test.com');
    });
    test('Test ExtraDependency parsing with license txt', () {
      final data = <String, dynamic>{
        'license': 'test.txt',
      };
      final yamlMap = YamlMap.wrap(data);
      final dependency = ExtraDependency.fromJson('test_package', yamlMap);
      expect(dependency.name, 'test_package');
      expect(dependency.isDevDependency, false);
      expect(dependency.isExtraDependency, false);
      expect(dependency.isGitDependency, false);
      expect(dependency.gitPath, null);
      expect(dependency.isLocalDependency, false);
      expect(dependency.localPath, null);
      expect(dependency.isPartOfFlutterSdk, false);
      expect(dependency.isPartOfFlutterSdk, false);
      expect(dependency.homepageUrl, null);
      expect(dependency.repositoryUrl, null);
      expect(dependency.licenseUrl, 'test.txt');
    });
    test('Test ExtraDependency parsing with repo url', () {
      final data = <String, dynamic>{
        'license': 'https://test.com',
        'repository': 'https://test.com',
      };
      final yamlMap = YamlMap.wrap(data);
      final dependency = ExtraDependency.fromJson('test_package', yamlMap);
      expect(dependency.name, 'test_package');
      expect(dependency.isDevDependency, false);
      expect(dependency.isExtraDependency, false);
      expect(dependency.isGitDependency, false);
      expect(dependency.gitPath, null);
      expect(dependency.isLocalDependency, false);
      expect(dependency.localPath, null);
      expect(dependency.isPartOfFlutterSdk, false);
      expect(dependency.isPartOfFlutterSdk, false);
      expect(dependency.homepageUrl, null);
      expect(dependency.repositoryUrl, 'https://test.com');
      expect(dependency.licenseUrl, 'https://test.com');
    });
    test('Test ExtraDependency parsing with homepage url', () {
      final data = <String, dynamic>{
        'license': 'https://test.com',
        'homepage': 'https://test.com',
      };
      final yamlMap = YamlMap.wrap(data);
      final dependency = ExtraDependency.fromJson('test_package', yamlMap);
      expect(dependency.name, 'test_package');
      expect(dependency.isDevDependency, false);
      expect(dependency.isExtraDependency, false);
      expect(dependency.isGitDependency, false);
      expect(dependency.gitPath, null);
      expect(dependency.isLocalDependency, false);
      expect(dependency.localPath, null);
      expect(dependency.isPartOfFlutterSdk, false);
      expect(dependency.isPartOfFlutterSdk, false);
      expect(dependency.homepageUrl, 'https://test.com');
      expect(dependency.repositoryUrl, null);
      expect(dependency.licenseUrl, 'https://test.com');
    });
  });
}
