import 'package:test/test.dart';
import '../../bin/src/model/pubspec.dart';
import '../../bin/src/model/exception/fatal_exception.dart';
import '../../bin/src/command/check_command.dart';
import '../../bin/src/util/console_util.dart';
import '../util/test_stdin.dart';

void main() {
  group('Test check command', () {
    test('Test checkCommand without dependencies', () {
      const yaml = r'''
name: test_example
dependencies:
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
''';
      final params = Params(yaml, lock);
      params.dependencies.clear();
      params.pubspecLock.dependencies.clear();
      const CheckCommand().checkDependencies(params);
    });

    test('Test checkCommand with dependency but no locked dependencies', () {
      const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
  license_generator: 1.0.0
  test_package: 1.0.0
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
''';
      final params = Params(yaml, lock);
      expect(
        () => const CheckCommand().checkDependencies(params),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message ==
                'test_package is not yet included in the pubspec.lock. Make sure you run packages get')),
      );
    });

    test('Test checkCommand with dependency & locked dependencies', () {
      const yaml = r'''
name: test_example
dependencies:
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
''';
      final params = Params(yaml, lock);
      const CheckCommand().checkDependencies(params);
    });

    test('Test checkCommand with dependency & locked dependencies missmatch',
        () {
      final stdin = TestStdinSync();
      ConsoleUtil.setStdin(stdin);
      stdin.addInputString('n');
      const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
  license_generator: 1.0.0
  test_package: 1.0.0
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
      expect(
        () => const CheckCommand().checkDependencies(params),
        throwsA(predicate((e) =>
            e is FatalException &&
            e.message == 'We found some version mismatches: 1')),
      );
    });

    test('Test checkCommand with dependency & locked dependencies missmatch',
        () {
      final stdin = TestStdinSync();
      ConsoleUtil.setStdin(stdin);
      stdin.addInputString('y');
      const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
  license_generator: 1.0.0
  test_package: 1.0.0
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
      expect(
        () => const CheckCommand().checkDependencies(params),
        throwsA(predicate((e) =>
            e is FatalException &&
            e.message == 'We found some version mismatches: 1')),
      );
    });

    test(
        'Test checkCommand with dependency & locked dependencies missmatch & fail fast',
        () {
      const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
  license_generator: 1.0.0
  test_package: 1.0.0
license_generator:
  fail_fast: true
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
      expect(
        () => const CheckCommand().checkDependencies(params),
        throwsA(predicate((e) =>
            e is FatalException &&
            e.message ==
                'test_package is 1.0.0 in your pubspec. Your pubspec.lock is using 1.0.1')),
      );
    });
  });
}
