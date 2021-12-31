import 'package:meta/meta.dart';

@immutable
class DependencyLicenseData {
  final String license;
  final String? homepageUrl;
  final String? repositoryUrl;

  const DependencyLicenseData({
    required this.license,
    this.homepageUrl,
    this.repositoryUrl,
  });
}
