import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'dependency.dart';

@immutable
class ExtraDependency extends Dependency {
  final String licenseUrl;
  final String? homepageUrl;
  final String? repositoryUrl;

  const ExtraDependency({
    required String name,
    required String? version,
    required this.homepageUrl,
    required this.repositoryUrl,
    required this.licenseUrl,
    required bool isDevDependency,
    required bool isPartOfFlutterSdk,
  }) : super(
          name: name,
          version: version,
          isDevDependency: isDevDependency,
          isPartOfFlutterSdk: isPartOfFlutterSdk,
          isLocalDependency: false,
          isGitDependency: false,
        );

  factory ExtraDependency.fromJson(String package, YamlMap json) {
    final name = json['name'] as String?;
    return ExtraDependency(
      name: name ?? package,
      licenseUrl: json['license'] as String,
      version: json['version'] as String?,
      homepageUrl: json['homepage'] as String?,
      repositoryUrl: json['repository'] as String?,
      isDevDependency: json['dev_dependency'] == 'true',
      isPartOfFlutterSdk: json['part_of_flutter_sdk'] == 'true',
    );
  }
}
