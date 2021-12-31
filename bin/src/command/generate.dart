import 'dart:io';

import 'package:path/path.dart';

import '../extension/string_builder_extension.dart';
import '../model/dto/dependency.dart';
import '../model/dto/dependency_lock.dart';
import '../model/pubspec.dart';
import '../repo/license_repo.dart';
import '../util/logger.dart';
import 'check.dart';

class GenerateCommand {
  GenerateCommand._();

  static Future<void> generateLicenses(Params params) async {
    if (params.checkBeforGenerate) {
      CheckCommand.checkDependencies(params);
      Logger.logInfo('\n\nYour pubspec.yaml & pubspec.lock are in sync. Generating the dart license file.\n\n');
    }
    final outputFilePath = join('lib', 'util', 'license.dart');
    final outputFile = File(outputFilePath);
    if (!outputFile.existsSync()) {
      outputFile.createSync(recursive: true);
    }

    final sb = StringBuffer()
      ..writeln('//============================================================//')
      ..writeln('//THIS FILE IS AUTO GENERATED. DO NOT EDIT//')
      ..writeln('//============================================================//')
      ..writeln()
      ..writeln('class License {')
      ..writeln('  final String name;')
      ..writeln('  final String license;')
      ..writeln('  final String? version;')
      ..writeln('  final String? homepage;')
      ..writeln('  final String? repository;')
      ..writeln()
      ..writeln('  License({')
      ..writeln('   required this.name,')
      ..writeln('   required this.license,')
      ..writeln('   this.version,')
      ..writeln('   this.homepage,')
      ..writeln('   this.repository,')
      ..writeln('  });')
      ..writeln('}');

    final dependencies = <Dependency, DependencyLock>{};
    final sortedDependencies = params.dependencies..sort((a1, a2) => a1.name.compareTo(a2.name));
    for (final dependency in sortedDependencies) {
      final matchingDependencies = params.pubspecLock.dependencies.where((element) => element.name == dependency.name);
      if (matchingDependencies.isEmpty) {
        throw Exception('Make sure you run packages get before the license_generator');
      }
      dependencies[dependency] = matchingDependencies.first;
    }

    sb
      ..writeln('class LicenseUtil {')
      ..writeln('  LicenseUtil._();')
      ..writeln()
      ..writeln('  static List<License> getLicenses() {')
      ..writeln('    return [');

    for (final dependency in dependencies.keys) {
      final lockedDependency = dependencies[dependency];
      if (lockedDependency == null) {
        throw Exception('${dependency.name} could not be found in the dependency map');
      }
      sb.write(await _getDependencyText(params, dependency, lockedDependency));
    }

    sb
      ..writeln('    ];')
      ..writeln('  }')
      ..writeln('}');

    outputFile.writeAsStringSync(sb.toString());
  }

  static Future<String> _getDependencyText(Params params, Dependency dependency, DependencyLock lockedDependency) async {
    final licenseData = await LicenseRepo.getLicenseData(params, dependency, lockedDependency);
    final sb = StringBuffer()
      ..writeln('      License(')
      ..writelnWithQuotesOrNull('name', dependency.name)
      ..writeln('        license: \'\'\'${licenseData.license}\'\'\',')
      ..writelnWithQuotesOrNull('version', dependency.getVersion(lockedDependency))
      ..writelnWithQuotesOrNull('homepage', licenseData.homepageUrl)
      ..writelnWithQuotesOrNull('repository', licenseData.repositoryUrl)
      ..writeln('      ),');
    return sb.toString();
  }
}