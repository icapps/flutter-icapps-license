import 'pubspec.dart';

class Package {
  final PubSpec pubspec;

  Package({
    required this.pubspec,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      pubspec: PubSpec.fromJson(
          json['pubspec'] as Map<String, dynamic>), // ignore: avoid_as
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pubspec': pubspec,
    };
  }
}
