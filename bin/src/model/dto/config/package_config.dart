import 'package:meta/meta.dart';

import 'package.dart';

@immutable
class PackageConfig {
  final List<CachedPackage> packages;

  const PackageConfig({
    required this.packages,
  });

  factory PackageConfig.fromJson(Map<String, dynamic> json) {
    return PackageConfig(
      packages: (json['packages'] as List<dynamic>).map((dynamic e) => CachedPackage.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'packages': packages,
    };
  }
}
