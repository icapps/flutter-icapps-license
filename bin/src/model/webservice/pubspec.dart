class PubSpec {
  final String name;
  final String version;
  final String homepage;

  PubSpec(this.name, this.version, this.homepage);

  factory PubSpec.fromJson(Map<String, dynamic> json) {
    return PubSpec(
      json['name'] as String,
      json['version'] as String,
      json['homepage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'homepage': homepage,
    };
  }
}
