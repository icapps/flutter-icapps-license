import 'dart:io' show Platform;

import 'package:meta/meta.dart';

@immutable
class CachedPackage {
  final String name;
  final String rootUri;
  final String packageUri;

  const CachedPackage({
    required this.name,
    required this.rootUri,
    required this.packageUri,
  });

  factory CachedPackage.fromJson(Map<String, dynamic> json) {
    var rootUri = json['rootUri'] as String;
    if (rootUri.startsWith(_rootUriPrefixOnPlatform())) {
      rootUri = rootUri.replaceFirst(_rootUriPrefixOnPlatform(), '');
    }
    if (rootUri.startsWith('../')) {
      rootUri = rootUri.replaceFirst('../', '');
    }
    return CachedPackage(
      name: json['name'] as String,
      rootUri: rootUri,
      packageUri: json['packageUri'] as String,
    );
  }

  static String _rootUriPrefixOnPlatform() {
    if (Platform.isWindows) {
      return 'file:///';
    }
    return 'file://';
  }
}
