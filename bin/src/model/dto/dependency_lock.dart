import 'package:yaml/yaml.dart';

class DependencyLock {
  final String name;
  final String version;
  final String? source;
  final bool isTransitiveDependency;
  final bool isDirectMainDependency;
  final bool isDirectDevDependency;

  DependencyLock({
    required this.name,
    required this.version,
    required this.source,
    required this.isTransitiveDependency,
    required this.isDirectMainDependency,
    required this.isDirectDevDependency,
  });

  factory DependencyLock.fromJson(String package, YamlMap json) {
    final dependency = json['dependency'] as String;
    return DependencyLock(
      name: package,
      version: json['version'] as String,
      source: json['source'] as String?,
      isTransitiveDependency: dependency == 'transitive',
      isDirectMainDependency: dependency == 'direct main',
      isDirectDevDependency: dependency == 'direct dev',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'version': version,
      'source': source,
      'isTransitiveDependency': isTransitiveDependency,
      'isDirectMainDependency': isDirectMainDependency,
      'isDirectDevDependency': isDirectDevDependency,
    };
  }
}
