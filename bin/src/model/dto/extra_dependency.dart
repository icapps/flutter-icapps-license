import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'dependency.dart';

@immutable
class ExtraDependency extends Dependency {
  final String? homepageUrl;
  final String? repositoryUrl;
  final String? licenseUrl;

  const ExtraDependency({
    required String name,
    required String? version,
    required this.homepageUrl,
    required this.repositoryUrl,
    required this.licenseUrl,
    required bool isDevDependency,
    required bool isPartOfFlutterSdk,
    required String? localPath,
  }) : super(
          name: name,
          version: version,
          isDevDependency: isDevDependency,
          isPartOfFlutterSdk: isPartOfFlutterSdk,
          isLocalDependency: localPath != null,
          localPath: localPath,
          isGitDependency: false,
        );

  factory ExtraDependency.fromJson(String package, YamlMap json) {
    final license = json['license'] as String?;
    String? licenseUrl;
    String? localPath;
    if (license != null && license.startsWith('http')) {
      licenseUrl = license;
    } else if (license != null) {
      localPath = license;
    }
    return ExtraDependency(
      name: package,
      version: json['version'] as String?,
      homepageUrl: json['homepage'] as String?,
      repositoryUrl: json['repository'] as String?,
      licenseUrl: licenseUrl,
      localPath: localPath,
      isDevDependency: json['dev_dependency'] == 'true',
      isPartOfFlutterSdk: json['part_of_flutter_sdk'] == 'true',
    );
  }
}
