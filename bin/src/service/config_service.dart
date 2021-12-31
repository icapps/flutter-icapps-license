import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../model/dto/config/cached_package.dart';
import '../model/dto/config/package_config.dart';
import '../model/dto/dependency.dart';
import '../model/dto/dependency_lock.dart';

const _path = '.dart_tool/package_config.json';

@immutable
class ConfigService {
  const ConfigService._();

  static Future<CachedPackage> getConfigData(Dependency dependency, DependencyLock lockedDependency) async {
    final file = File(_path);
    if (!file.existsSync()) {
      throw Exception('$_path does not exists. Make sure you run packages get before license_generator');
    }
    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;
    final packageConfig = PackageConfig.fromJson(json);
    return packageConfig.packages.firstWhere((element) => element.name == dependency.name);
  }
}
