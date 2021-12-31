import 'package:yaml/yaml.dart';

import 'dto/dependency_lock.dart';

const rawGithubDomain = 'https://raw.githubusercontent.com';
const githubDomain = 'https://github.com';
const licensePath = '/master/LICENSE';
const licensePathShort = '/LICENSE';

class PubspecLock {
  final _dependencies = <DependencyLock>[];

  List<DependencyLock> get dependencies => _dependencies;

  List<DependencyLock> get transitiveDependencies => _dependencies.where((element) => element.isTransitiveDependency).toList();

  List<DependencyLock> get mainDependencies => _dependencies.where((element) => element.isDirectMainDependency).toList();

  List<DependencyLock> get devDependencies => _dependencies.where((element) => element.isDirectDevDependency).toList();

  PubspecLock(String pubspecContent) {
    final config = loadYaml(pubspecContent) as YamlMap;
    final packages = config['packages'] as YamlMap?;
    if (packages == null) throw Exception('Did you forget to run flutter packages get');

    for (final package in packages.keys) {
      if (package is! String) throw ArgumentError('package should be a String, the name of the package');
      final values = packages.value[package] as YamlMap;
      final dependencyLock = DependencyLock.fromJson(package, values);
      _dependencies.add(dependencyLock);
    }
  }
}
