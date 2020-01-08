class PubSpec {
  final String name;
  final String version;
  final String homepage;
  final String repository;

  PubSpec(
    this.name,
    this.version,
    this.homepage,
    this.repository,
  );

  factory PubSpec.fromJson(Map<String, dynamic> json) {
    return PubSpec(
      json['name'] as String,
      json['version'] as String,
      json['homepage'] as String,
      json['repository'] as String,
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
