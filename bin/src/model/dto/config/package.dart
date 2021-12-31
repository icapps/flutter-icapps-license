class CachedPackage {
  final String name;
  final String rootUri;
  final String packageUri;

  CachedPackage({
    required this.name,
    required this.rootUri,
    required this.packageUri,
  });

  factory CachedPackage.fromJson(Map<String, dynamic> json) {
    var rootUri = json['rootUri'] as String;
    if (rootUri.startsWith('file://')) {
      rootUri = rootUri.replaceFirst('file://', '');
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'rootUri': rootUri,
      'packageUri': packageUri,
    };
  }
}