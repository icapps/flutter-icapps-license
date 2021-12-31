import 'dart:convert';

import 'package:test/test.dart';
import '../../../../bin/src/model/dto/config/cached_package.dart';

void main() {
  group('Test cached package', () {
    test('test ../', () {
      const packageConfigJson = r'''
{
  "name": "license_generator",
  "rootUri": "../",
  "packageUri": "lib/",
  "languageVersion": "2.12"
}
''';

      final json = jsonDecode(packageConfigJson) as Map<String, dynamic>;
      final package = CachedPackage.fromJson(json);
      expect(package.name, 'license_generator');
      expect(package.rootUri, '');
      expect(package.packageUri, 'lib/');
    });
    test('test file://', () {
      const packageConfigJson = r'''
{
  "name": "yaml",
  "rootUri": "file:///Users/myuser/.pub-cache/hosted/pub.dartlang.org/yaml-3.1.0",
  "packageUri": "lib/",
  "languageVersion": "2.12"
}
''';

      final json = jsonDecode(packageConfigJson) as Map<String, dynamic>;
      final package = CachedPackage.fromJson(json);
      expect(package.name, 'yaml');
      expect(package.rootUri, '/Users/myuser/.pub-cache/hosted/pub.dartlang.org/yaml-3.1.0');
      expect(package.packageUri, 'lib/');
    });
  });
}
