import 'pubspec.dart';

class Package {
  final PubSpec pubspec;

  Package(this.pubspec);

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      PubSpec.fromJson(json['pubspec'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pubspec': pubspec,
    };
  }
}
