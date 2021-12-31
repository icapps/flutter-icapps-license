import 'package:meta/meta.dart';

import 'pub_dev_pubspec.dart';

@immutable
class PubDevPackage {
  final PubDevPubSpec pubspec;

  const PubDevPackage({
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
