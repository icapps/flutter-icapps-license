class PubSpec {
  final String name;
  final String version;
  final String? homepage;
  final String? repository;

  PubSpec({
    required this.name,
    required this.version,
    required this.homepage,
    required this.repository,
  });

  factory PubSpec.fromJson(Map<String, dynamic> json) {
    return PubSpec(
      name: json['name'] as String, // ignore: avoid_as
      version: json['version'] as String, // ignore: avoid_as
      homepage: json['homepage'] as String?, // ignore: avoid_as
      repository: json['repository'] as String?, // ignore: avoid_as
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'homepage': homepage,
      'repository': repository,
    };
  }
}
