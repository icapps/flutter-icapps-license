import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import '../../../bin/src/model/dto/dependency_lock.dart';

void main() {
  group('Test DependencyLock', () {
    test('test dependency lock from json', () {
      final json = YamlMap.wrap(<String, dynamic>{
        'version': '1.0.0',
        'dependency': '',
      });
      final dependencyLock = DependencyLock.fromJson('test_package', json);
      expect(dependencyLock.name, 'test_package');
      expect(dependencyLock.isTransitiveDependency, false);
      expect(dependencyLock.isDirectDevDependency, false);
      expect(dependencyLock.isDirectMainDependency, false);
      expect(dependencyLock.source, null);
      expect(dependencyLock.version, '1.0.0');
    });
    test('test dependency lock from json direct main', () {
      final json = YamlMap.wrap(<String, dynamic>{
        'version': '1.0.0',
        'dependency': 'direct main',
      });
      final dependencyLock = DependencyLock.fromJson('test_package', json);
      expect(dependencyLock.name, 'test_package');
      expect(dependencyLock.isTransitiveDependency, false);
      expect(dependencyLock.isDirectDevDependency, false);
      expect(dependencyLock.isDirectMainDependency, true);
      expect(dependencyLock.source, null);
      expect(dependencyLock.version, '1.0.0');
    });
    test('test dependency lock from json direct dev', () {
      final json = YamlMap.wrap(<String, dynamic>{
        'version': '1.0.0',
        'dependency': 'direct dev',
      });
      final dependencyLock = DependencyLock.fromJson('test_package', json);
      expect(dependencyLock.name, 'test_package');
      expect(dependencyLock.isTransitiveDependency, false);
      expect(dependencyLock.isDirectDevDependency, true);
      expect(dependencyLock.isDirectMainDependency, false);
      expect(dependencyLock.source, null);
      expect(dependencyLock.version, '1.0.0');
    });
    test('test dependency lock from json travisive', () {
      final json = YamlMap.wrap(<String, dynamic>{
        'version': '1.0.0',
        'dependency': 'transitive',
      });
      final dependencyLock = DependencyLock.fromJson('test_package', json);
      expect(dependencyLock.name, 'test_package');
      expect(dependencyLock.isTransitiveDependency, true);
      expect(dependencyLock.isDirectDevDependency, false);
      expect(dependencyLock.isDirectMainDependency, false);
      expect(dependencyLock.source, null);
      expect(dependencyLock.version, '1.0.0');
    });
  });
}
