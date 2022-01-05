import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../model/dto/config/cached_package.dart';
import '../model/dto/config/package_config.dart';
import '../model/dto/dependency.dart';
import '../model/dto/dependency_lock.dart';
import '../model/exception/fatal_exception.dart';

const _path = '.dart_tool/package_config.json';

@immutable
class ConfigService {
  final String path;

  const ConfigService({
    this.path = _path,
  });

  Future<CachedPackage> getConfigData(
      Dependency dependency, DependencyLock lockedDependency) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw FatalException(
          '$path does not exists. Make sure you run packages get before license_generator');
    }
    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;
    final packageConfig = PackageConfig.fromJson(json);
    return packageConfig.packages
        .firstWhere((element) => element.name == dependency.name);
  }
}
