import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'dependency_lock.dart';

@immutable
class Dependency {
  final String name;
  final bool isDevDependency;
  final bool isPartOfFlutterSdk;
  final bool isLocalDependency;
  final String? localPath;
  final bool isGitDependency;
  final GitInfo? gitPath;
  final bool isExtraDependency;
  final String? version;

  const Dependency({
    required this.name,
    required this.isDevDependency,
    required this.isPartOfFlutterSdk,
    required this.isLocalDependency,
    required this.isGitDependency,
    this.localPath,
    this.gitPath,
    this.version,
    this.isExtraDependency = false,
  });

  factory Dependency.fromJson({required String package, required bool isDevDependency, required YamlMap data}) {
    final sdk = data['sdk'] as String?;
    final path = data['path'] as String?;
    final git = data['git'] as YamlMap?;
    return Dependency(
      name: package,
      isDevDependency: isDevDependency,
      isExtraDependency: false,
      isLocalDependency: path != null,
      localPath: path,
      isGitDependency: git != null,
      gitPath: _getGitPath(git),
      isPartOfFlutterSdk: sdk == 'flutter',
    );
  }

  factory Dependency.fromWithVersion({required String package, required bool isDevDependency, required String version}) {
    return Dependency(
      name: package,
      version: version,
      isDevDependency: isDevDependency,
      isExtraDependency: false,
      isLocalDependency: false,
      isGitDependency: false,
      isPartOfFlutterSdk: false,
      localPath: null,
    );
  }

  String? getVersion(DependencyLock lockedDependency) {
    if (isPartOfFlutterSdk) {
      return version;
    } else {
      return version ?? lockedDependency.version;
    }
  }

  static GitInfo? _getGitPath(YamlMap? git) {
    if (git == null) return null;
    final url = git['url'] as String;
    final path = git['path'] as String?;
    final ref = git['ref'] as String?;
    return GitInfo(
      url: url,
      path: path,
      ref: ref,
    );
  }
}

class GitInfo {
  final String url;
  final String? path;
  final String? ref;

  GitInfo({
    required this.url,
    this.path,
    this.ref,
  });
}
