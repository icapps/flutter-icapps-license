import 'pub_dev_pubspec.dart';

class PubDevPackage {
  final PubDevPubSpec pubspec;

  PubDevPackage({
    required this.pubspec,
  });

  factory PubDevPackage.fromJson(Map<String, dynamic> json) {
    return PubDevPackage(
      pubspec: PubDevPubSpec.fromJson(
        json['pubspec'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pubspec': pubspec,
    };
  }
}
