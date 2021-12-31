import 'package:test/test.dart';
import '../../bin/src/model/pubspec.dart';
import '../../bin/src/model/exception/fatal_exception.dart';
import '../../bin/src/model/dto/dependency.dart';
import '../../bin/src/model/dto/dependency_lock.dart';
import '../../bin/src/command/check_command.dart';
import '../../bin/src/util/console_util.dart';

void main() {
  group('Test check command', () {
    test('Test checkCommand without dependencies', () {
      final params = Params();
      CheckCommand.checkDependencies(params);
    });
    test('Test checkCommand without dependencies', () {
      final params = Params();
      CheckCommand.checkDependencies(params);
    });
    test('Test checkCommand with dependency but no locked dependencies', () {
      final params = Params();
      params.dependencies.add(Dependency(
        name: 'test_package',
        version: '1.0.0',
        isGitDependency: false,
        isLocalDependency: false,
        isPartOfFlutterSdk: false,
        isDevDependency: false,
      ));
      expect(
        () => CheckCommand.checkDependencies(params),
        throwsA(predicate((e) => e is ArgumentError && e.message == 'test_package is not yet included in the pubspec.lock. Make sure you run pacakges get')),
      );
    });
    test('Test checkCommand with dependency & locked dependencies', () {
      final params = Params();
      params.dependencies.add(Dependency(
        name: 'test_package',
        version: '1.0.0',
        isGitDependency: false,
        isLocalDependency: false,
        isPartOfFlutterSdk: false,
        isDevDependency: false,
      ));
      params.pubspecLock.dependencies.add(DependencyLock(
        name: 'test_package',
        version: '1.0.0',
        isDirectMainDependency: true,
        isTransitiveDependency: false,
        isDirectDevDependency: false,
        source: 'pub.dev',
      ));
      CheckCommand.checkDependencies(params);
    });

    test('Test checkCommand with dependency & locked dependencies missmatch', () {
      ConsoleUtil.returnInTest('n');
      final params = Params();
      params.dependencies.add(Dependency(
        name: 'test_package',
        version: '1.0.0',
        isGitDependency: false,
        isLocalDependency: false,
        isPartOfFlutterSdk: false,
        isDevDependency: false,
      ));
      params.pubspecLock.dependencies.add(DependencyLock(
        name: 'test_package',
        version: '1.0.1',
        isDirectMainDependency: true,
        isTransitiveDependency: false,
        isDirectDevDependency: false,
        source: 'pub.dev',
      ));
      expect(
        () => CheckCommand.checkDependencies(params),
        throwsA(predicate((e) => e is FatalException && e.message == 'We found some dependency mismatches: 1')),
      );
    });

    test('Test checkCommand with dependency & locked dependencies missmatch & fail fast', () {
      final params = Params();
      params.failFast = true;
      params.dependencies.add(Dependency(
        name: 'test_package',
        version: '1.0.0',
        isGitDependency: false,
        isLocalDependency: false,
        isPartOfFlutterSdk: false,
        isDevDependency: false,
      ));
      params.pubspecLock.dependencies.add(DependencyLock(
        name: 'test_package',
        version: '1.0.1',
        isDirectMainDependency: true,
        isTransitiveDependency: false,
        isDirectDevDependency: false,
        source: 'pub.dev',
      ));
      expect(
        () => CheckCommand.checkDependencies(params),
        throwsA(predicate((e) => e is FatalException && e.message == 'test_package is 1.0.0 in your pubspec. Your pubspec.lock is using 1.0.1')),
      );
    });
  });
}
