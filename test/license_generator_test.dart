import 'dart:io';

import 'package:path/path.dart';
import 'package:test/test.dart';
import '../bin/src/license_generator.dart';
import '../bin/src/model/exception/fatal_exception.dart';
import '../bin/license_generator.dart' as entry_point;

void main() {
  final pubspecPath = join(Directory.current.path, 'test', 'license_generator_pubspec.yaml');
  final pubspecLockPath = join(Directory.current.path, 'test', 'license_generator_pubspec.lock');
  group('Test License Generator', () {
    test('Test main', () {
      entry_point.main([]);
    });
    test('Test license generator with no arguments', () {
      expect(
        () async => LicenseGenerator([]),
        throwsA(predicate((e) => e is FatalException && e.message == 'license_generator should be started with `check` or `generate`')),
      );
    });
    test('Test license generator with check', () async {
      expect(
        () async => LicenseGenerator(
          ['check'],
        ),
        throwsA(predicate((e) => e is FatalException && e.message == 'license_generator should be added to the dev_dependencies.')), //because the pubspec.yaml of the root is used
      );
    });
    test('Test license generator with check', () async {
      final licenseGenerator = LicenseGenerator(
        ['check'],
        pubspecPath: pubspecPath,
        pubspecLockPath: pubspecLockPath,
      );
      await licenseGenerator.run();
    });
    test('Test license generator with non existing pubspec.yaml', () async {
      expect(
        () async => LicenseGenerator(
          ['check'],
          pubspecPath: pubspecPath + 'does-not-exist',
          pubspecLockPath: pubspecLockPath,
        ),
        throwsA(predicate((e) => e is FatalException && e.message == 'This program should be run from the root of a flutter/dart project')),
      );
    });
    test('Test license generator with non existing pubspec.lock', () async {
      expect(
        () async => LicenseGenerator(
          ['check'],
          pubspecPath: pubspecPath,
          pubspecLockPath: pubspecLockPath + 'does-not-exist',
        ),
        throwsA(predicate((e) => e is FatalException && e.message == 'pubspec.lock is missing. Make sure you run flutter packages get')),
      );
    });
    group('log check', () {
      test('Test license generator with log info', () async {
        final licenseGenerator = LicenseGenerator(
          [
            'check',
            'info',
          ],
          pubspecPath: pubspecPath,
          pubspecLockPath: pubspecLockPath,
        );
        await licenseGenerator.run();
      });
      test('Test license generator with log debug', () async {
        final licenseGenerator = LicenseGenerator(
          [
            'check',
            'debug',
          ],
          pubspecPath: pubspecPath,
          pubspecLockPath: pubspecLockPath,
        );
        await licenseGenerator.run();
      });
      test('Test license generator with log verbose', () async {
        final licenseGenerator = LicenseGenerator(
          [
            'check',
            'verbose',
          ],
          pubspecPath: pubspecPath,
          pubspecLockPath: pubspecLockPath,
        );
        await licenseGenerator.run();
      });
    });
    group('Output files', () {
      final outputPath = join(Directory.current.path, 'test', 'license_generator_output.txt');
      tearDown(() {
        File(outputPath).deleteSync();
      });

      test('Test license generator with generate', () async {
        final licenseGenerator = LicenseGenerator(
          ['generate'],
          pubspecPath: pubspecPath,
          pubspecLockPath: pubspecLockPath,
        );
        licenseGenerator.overrideFileOuputPath(outputPath);
        await licenseGenerator.run();
      });

      group('log generate', () {
        test('Test license generator with generate log info', () async {
          final licenseGenerator = LicenseGenerator(
            [
              'generate',
              'info',
            ],
            pubspecPath: pubspecPath,
            pubspecLockPath: pubspecLockPath,
          );
          licenseGenerator.overrideFileOuputPath(outputPath);
          await licenseGenerator.run();
        });
        test('Test license generator with generate log debug', () async {
          final licenseGenerator = LicenseGenerator(
            [
              'generate',
              'debug',
            ],
            pubspecPath: pubspecPath,
            pubspecLockPath: pubspecLockPath,
          );
          licenseGenerator.overrideFileOuputPath(outputPath);
          await licenseGenerator.run();
        });
        test('Test license generator with generate log verbose', () async {
          final licenseGenerator = LicenseGenerator(
            [
              'generate',
              'verbose',
            ],
            pubspecPath: pubspecPath,
            pubspecLockPath: pubspecLockPath,
          );
          licenseGenerator.overrideFileOuputPath(outputPath);
          await licenseGenerator.run();
        });
      });
    });
  });
}
