import 'package:test/test.dart';
import '../../bin/src/model/pubspec.dart';
import '../../bin/src/model/exception/fatal_exception.dart';

void main() {
  group('Test Params', () {
    group('default', () {
      test('Test Params without license_generator', () {
        const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
''';
        const lock = r'''
packages:
''';
        expect(
          () => Params(yaml, lock),
          throwsA(predicate((e) => e is FatalException && e.message == 'license_generator should be added to the dev_dependencies.')),
        );
      });

      test('Test Params without name', () {
        const yaml = r'''
dependencies:
dev_dependencies:
''';
        const lock = r'''
packages:
''';
        expect(
          () => Params(yaml, lock),
          throwsA(predicate((e) => e is FatalException && e.message == 'Could not parse the pubspec.yaml, project name not found')),
        );
      });

      test('Test Params with path', () {
        const yaml = r'''
name: test_example
dependencies:
  test_package:
    path: ../
dev_dependencies:
  license_generator: 1.0.0
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        Params(yaml, lock);
      });

      test('Test Params with yaml list (not supported)', () {
        const yaml = r'''
name: test_example
dependencies:
  test_package:
    - test
    - test
dev_dependencies:
  license_generator: 1.0.0
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        expect(
          () => Params(yaml, lock),
          throwsA(predicate((e) => e is FatalException && e.message == 'YamlList (dependencies) is no String or YamlMap')),
        );
      });

      test('Test Params with yaml list (not supported) dev', () {
        const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
  license_generator: 1.0.0
  test_package:
    - test
    - test  
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        expect(
          () => Params(yaml, lock),
          throwsA(predicate((e) => e is FatalException && e.message == 'YamlList (dev_dependencies) is no String or YamlMap')),
        );
      });
    });
    group('override', () {
      test('Test Params with license_override', () {
        const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
  license_generator: 1.0.0
  test_package: 1.0.0
license_generator:
  licenses:
    test_package: test.md
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        final params = Params(yaml, lock);
        expect(params.dependencyOverrides.length, 1);
        expect(params.dependencyOverrides.keys.first, 'test_package');
        expect(params.dependencyOverrides.values.first, 'test.md');
      });

      test('Test Params with license_override', () {
        const yaml = r'''
name: test_example
dependencies:
  test_package: 1.0.0
dev_dependencies:
  license_generator: 1.0.0
license_generator:
  licenses:
    test_package: test.md
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        final params = Params(yaml, lock);
        expect(params.dependencyOverrides.length, 1);
        expect(params.dependencyOverrides.keys.first, 'test_package');
        expect(params.dependencyOverrides.values.first, 'test.md');
      });

      test('Test Params with license_override non string (yaml list)', () {
        const yaml = r'''
name: test_example
dependencies:
  test_package: 1.0.0
dev_dependencies:
  license_generator: 1.0.0
license_generator:
  licenses:
    test_package:
      - test
      - test
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        expect(
              () => Params(yaml, lock),
          throwsA(predicate((e) => e is FatalException && e.message == 'YamlList is no String')),
        );
      });

      test('Test Params with license_override non string (yaml map)', () {
        const yaml = r'''
name: test_example
dependencies:
  test_package: 1.0.0
dev_dependencies:
  license_generator: 1.0.0 
license_generator:
  licenses:
    test_package:
      path: ../
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        expect(
              () => Params(yaml, lock),
          throwsA(predicate((e) => e is FatalException && e.message == 'YamlMap is no String')),
        );
      });
    });
    group('extra licenses', () {
      test('Test Params with license_override', () {
        const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
  license_generator: 1.0.0
  test_package: 1.0.0
license_generator:
  extra_licenses:
    test_package: 
      name: Test Package
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        final params = Params(yaml, lock);
        expect(params.extraDependencies.length, 1);
        expect(params.extraDependencies.first.name, 'test_package');
      });

      test('Test Params with license_override non string (yaml list)', () {
        const yaml = r'''
name: test_example
dependencies:
  test_package: 1.0.0
dev_dependencies:
  license_generator: 1.0.0
license_generator:
  extra_licenses:
    test_package:
      - test1
      - test2
      - test3
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        expect(
              () => Params(yaml, lock),
          throwsA(predicate((e) => e is FatalException && e.message == 'YamlList is no YamlMap')),
        );
      });

      test('Test Params with license_override non yaml map (string)', () {
        const yaml = r'''
name: test_example
dependencies:
  test_package: 1.0.0
dev_dependencies:
  license_generator: 1.0.0 
license_generator:
  extra_licenses: 
    test_package: test
''';
        const lock = r'''
packages:
  license_generator:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.0"
  test_package:
    dependency: "direct dev"
    description:
      path: ".."
      relative: true
    source: path
    version: "1.0.1"
''';
        expect(
              () => Params(yaml, lock),
          throwsA(predicate((e) => e is FatalException && e.message == 'String is no YamlMap')),
        );
      });
    });
  });
}
