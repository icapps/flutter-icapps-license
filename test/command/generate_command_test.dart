import 'dart:io';

import 'package:path/path.dart';
import 'package:test/test.dart';
import '../../bin/src/model/dto/dependency.dart';
import '../../bin/src/model/dto/dependency_license_data.dart';
import '../../bin/src/model/dto/dependency_lock.dart';
import '../../bin/src/model/dto/extra_dependency.dart';
import '../../bin/src/model/pubspec.dart';
import '../../bin/src/command/generate_command.dart';
import '../../bin/src/repo/license_repository.dart';

void main() {
  final outputPath = join(Directory.current.path, 'test', 'command', 'generate-command-output.txt');

  tearDown(() {
    File(outputPath).deleteSync();
  });

  group('Test generate command', () {
    test('Test generate command', () async {
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
      final repo = TestLicenseRepository({
        'license_generator': const DependencyLicenseData(license: 'this is the license_generator license'),
      });
      params.fileOutputPath = outputPath;
      final generateCommand = GenerateCommand(repo);
      await generateCommand.generateLicenses(params);
      final data = File(outputPath).readAsStringSync();
      expect(data, """import 'package:flutter/widgets.dart';

//============================================================//
//THIS FILE IS AUTO GENERATED. DO NOT EDIT//
//============================================================//

@immutable
class License {
  final String name;
  final String license;
  final String? version;
  final String? homepage;
  final String? repository;

  const License({
    required this.name,
    required this.license,
    this.version,
    this.homepage,
    this.repository,
  });
}

class LicenseUtil {
  LicenseUtil._();

  static List<License> getLicenses() {
    return [
      License(
        name: r'license_generator',
        license: r'''this is the license_generator license''',
        version: r'1.0.0',
        homepage: null,
        repository: null,
      ),
    ];
  }
}
""");
    });

    test('Test generate command with check before', () async {
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
      final repo = TestLicenseRepository({
        'license_generator': const DependencyLicenseData(license: 'this is the license_generator license'),
      });
      params.fileOutputPath = outputPath;
      params.checkBeforeGenerate = true;
      final generateCommand = GenerateCommand(repo);
      await generateCommand.generateLicenses(params);
      final data = File(outputPath).readAsStringSync();
      expect(data, """import 'package:flutter/widgets.dart';

//============================================================//
//THIS FILE IS AUTO GENERATED. DO NOT EDIT//
//============================================================//

@immutable
class License {
  final String name;
  final String license;
  final String? version;
  final String? homepage;
  final String? repository;

  const License({
    required this.name,
    required this.license,
    this.version,
    this.homepage,
    this.repository,
  });
}

class LicenseUtil {
  LicenseUtil._();

  static List<License> getLicenses() {
    return [
      License(
        name: r'license_generator',
        license: r'''this is the license_generator license''',
        version: r'1.0.0',
        homepage: null,
        repository: null,
      ),
    ];
  }
}
""");
    });

    test('Test generate command with extra licenses', () async {
      const yaml = r'''
name: test_example
dependencies:
dev_dependencies:
  license_generator: 1.0.0
license_generator:
  extra_licenses:
    license_generator:
      name: license_generator
      license: https://test.com
      repository: https://repository.com
      homepage: https://homepage.com
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
      final repo = TestLicenseRepository({
        'license_generator': const DependencyLicenseData(
          license: 'this is the license_generator license',
          repositoryUrl: 'https://repository.com',
          homepageUrl: 'https://homepage.com',
        ),
      });
      params.fileOutputPath = outputPath;
      final generateCommand = GenerateCommand(repo);
      await generateCommand.generateLicenses(params);
      final data = File(outputPath).readAsStringSync();
      print(data);
      expect(data, """import 'package:flutter/widgets.dart';

//============================================================//
//THIS FILE IS AUTO GENERATED. DO NOT EDIT//
//============================================================//

@immutable
class License {
  final String name;
  final String license;
  final String? version;
  final String? homepage;
  final String? repository;

  const License({
    required this.name,
    required this.license,
    this.version,
    this.homepage,
    this.repository,
  });
}

class LicenseUtil {
  LicenseUtil._();

  static List<License> getLicenses() {
    return [
      License(
        name: r'license_generator',
        license: r'''this is the license_generator license''',
        version: null,
        homepage: r'https://homepage.com',
        repository: r'https://repository.com',
      ),
    ];
  }
}
""");
    });
  });
}

class TestLicenseRepository implements LicenseRepository {
  final Map<String, DependencyLicenseData> data;

  TestLicenseRepository(this.data);

  @override
  Future<DependencyLicenseData> getLicenseDataForDependency(Params params, Dependency dependency, DependencyLock lockedDependency) async =>
      data.entries.firstWhere((element) => element.key == dependency.name).value;

  @override
  Future<DependencyLicenseData> getLicenseDataForExtraDependency(ExtraDependency dependency) async => data.entries.firstWhere((element) => element.key == dependency.name).value;
}
