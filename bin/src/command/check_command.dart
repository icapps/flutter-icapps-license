import 'package:meta/meta.dart';

import '../model/dto/dependency.dart';
import '../model/dto/dependency_lock.dart';
import '../model/exception/fatal_exception.dart';
import '../model/pubspec.dart';
import '../util/console_util.dart';
import '../util/logger.dart';

@immutable
class CheckCommand {
  const CheckCommand._();

  static void checkDependencies(Params params) {
    final versionMismatches = <Dependency, DependencyLock>{};
    for (final dependency in params.dependencies) {
      final lockDependencies = params.pubspecLock.dependencies.where((element) => element.name == dependency.name);
      if (lockDependencies.isEmpty) throw ArgumentError('${dependency.name} is not yet included in the pubspec.lock. Make sure you run packages get');
      final lockedDependency = lockDependencies.first;
      final checkVersion = !dependency.isPartOfFlutterSdk && !dependency.isLocalDependency && !dependency.isGitDependency;
      if (checkVersion && dependency.version?.replaceFirst('^', '') != lockedDependency.version) {
        if (params.failFast) {
          final message = '${dependency.name} is ${dependency.version} in your pubspec. Your pubspec.lock is using ${lockedDependency.version}';
          Logger.logInfo(message);
          throw FatalException(message);
        }
        versionMismatches[dependency] = lockedDependency;
      }
    }
    if (versionMismatches.isNotEmpty) {
      final message = 'We found some version mismatches: ${versionMismatches.length}';
      Logger.logInfo(message);
      final printDependencies = ConsoleUtil.readBoolean('Do you want to see all the dependencies? (y/n)');
      if (printDependencies) {
        for (final dependency in versionMismatches.keys) {
          final lockedDependency = versionMismatches[dependency];
          if (lockedDependency == null) {
            throw Exception('${dependency.name} could not be found in the version mismatch list');
          }
          Logger.logInfo('${dependency.name} is ${dependency.version} in your pubspec.yaml, your pubspec.lock is using ${lockedDependency.version}');
        }
      }
      throw FatalException(message);
    }
  }
}
