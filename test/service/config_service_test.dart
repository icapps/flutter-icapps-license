import 'dart:io';

import 'package:path/path.dart';
import 'package:test/test.dart';
import '../../bin/src/service/config_service.dart';
import '../../bin/src/model/dto/dependency.dart';
import '../../bin/src/model/exception/fatal_exception.dart';
import '../../bin/src/model/dto/dependency_lock.dart';

void main() {
  group('Test ConfigService', () {
    test('test this getConfigData', () async {
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
      final path = join(
        Directory.current.path,
        'test',
        'service',
        'config_service_test_data',
        'package_config.json',
      );
      final configService = ConfigService(path: path);
      final cachedPackage =
          await configService.getConfigData(dependency, lockedDependency);
      expect(cachedPackage.name, 'test_package');
      expect(cachedPackage.packageUri, 'lib/');
      expect(cachedPackage.rootUri,
          '/Users/myuser/.pub-cache/hosted/pub.dartlang.org/test_package-1.0.0');
    });
    test('test this getConfigData without file', () async {
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
      final path = join(
        Directory.current.path,
        'test',
        'service',
        'config_service_test_data',
        'package_config.json-does-not-exits',
      );
      final configService = ConfigService(path: path);
      expect(
        () async => configService.getConfigData(dependency, lockedDependency),
        throwsA(predicate((e) =>
            e is FatalException &&
            e.message ==
                '${Directory.current.path}/test/service/config_service_test_data/package_config.json-does-not-exits does not exists. Make sure you run packages get before license_generator')),
      );
    });
  });
}
