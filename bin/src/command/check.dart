import 'dart:io';

import '../model/dto/dependency.dart';
import '../model/dto/dependency_lock.dart';
import '../model/pubspec.dart';
import '../util/console_util.dart';
import '../util/logger.dart';

class CheckCommand {
  CheckCommand._();

  static void checkDependencies(Params params) {
    final dependencyMismatches = <Dependency, DependencyLock>{};
    for (final dependency in params.dependencies) {
      final lockDependencies = params.pubspecLock.dependencies.where((element) => element.name == dependency.name);
      if (lockDependencies.isEmpty) throw ArgumentError('${dependency.name} is not yet included in the pubspec.lock. Make sure you run ');
      final lockedDependency = lockDependencies.first;
      final checkVersion = !dependency.isPartOfFlutterSdk && !dependency.isLocalDependency && !dependency.isGitDependency;
      if (checkVersion && dependency.version?.replaceFirst('^', '') != lockedDependency.version) {
        if (params.failFast) {
          Logger.logInfo('${dependency.name} is ${dependency.version} in your pubspec. Your pubspec.lock is using ${lockedDependency.version}');
          exit(-1);
        }
        dependencyMismatches[dependency] = lockedDependency;
      }
    }
    if (dependencyMismatches.isNotEmpty) {
      Logger.logInfo('We found some dependency mismatches: ${dependencyMismatches.length}');
      final printDependencies = ConsoleUtil.readBoolean('Do you want to see all the dependencies? (y/n)');
      if (printDependencies) {
        for (final dependency in dependencyMismatches.keys) {
          final lockedDependency = dependencyMismatches[dependency];
          if (lockedDependency == null) {
            throw Exception('${dependency.name} could not be found in the dependency mismatch list');
          }
          Logger.logInfo('${dependency.name} is ${dependency.version} in your pubspec.yaml, your pubspec.lock is using ${lockedDependency.version}');
        }
      }
      exit(-1);
    }
  }
}
