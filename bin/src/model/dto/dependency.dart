class Dependency {
  final String name;
  final String license;
  final String? version;
  final String? licenseUrl;
  final String? url;

  Dependency({
    required this.name,
    required this.license,
    this.version,
    this.licenseUrl,
    this.url,
  });
}
