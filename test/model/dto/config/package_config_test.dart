import 'dart:convert';

import 'package:test/test.dart';
import '../../../../bin/src/model/dto/config/package_config.dart';

void main() {
  group('Test package config', () {
    test('Test package config parsing', () {
      const packageConfigJson = r'''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "_fe_analyzer_shared",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/_fe_analyzer_shared-19.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "analyzer",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/analyzer-1.3.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "args",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/args-2.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "async",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/async-2.5.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "boolean_selector",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/boolean_selector-2.1.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "charcode",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/charcode-1.2.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "cli_util",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/cli_util-0.3.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "collection",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/collection-1.15.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "convert",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/convert-3.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "coverage",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/coverage-1.0.2",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "crypto",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/crypto-3.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "file",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/file-6.1.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "flutter_lints",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/flutter_lints-1.0.4",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "glob",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/glob-2.0.1",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "http",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/http-0.13.1",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "http_multi_server",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/http_multi_server-3.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "http_parser",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/http_parser-4.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "io",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/io-1.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "js",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/js-0.6.3",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "lints",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/lints-1.0.1",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "logging",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/logging-1.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "matcher",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/matcher-0.12.10",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "meta",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/meta-1.3.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "mime",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/mime-1.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "node_preamble",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/node_preamble-2.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "package_config",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/package_config-2.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "path",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/path-1.8.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "pedantic",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/pedantic-1.11.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "pool",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/pool-1.5.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "pub_semver",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/pub_semver-2.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "shelf",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/shelf-1.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "shelf_packages_handler",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/shelf_packages_handler-3.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "shelf_static",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/shelf_static-1.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "shelf_web_socket",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/shelf_web_socket-1.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "source_map_stack_trace",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/source_map_stack_trace-2.1.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "source_maps",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/source_maps-0.10.10",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "source_span",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/source_span-1.8.1",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "stack_trace",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/stack_trace-1.10.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "stream_channel",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/stream_channel-2.1.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "string_scanner",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/string_scanner-1.1.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "term_glyph",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/term_glyph-1.2.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "test",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/test-1.16.8",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "test_api",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/test_api-0.3.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "test_core",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/test_core-0.3.19",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "typed_data",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/typed_data-1.3.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "vm_service",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/vm_service-6.1.0+1",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "watcher",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/watcher-1.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "web_socket_channel",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/web_socket_channel-2.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "webkit_inspection_protocol",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/webkit_inspection_protocol-1.0.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "yaml",
      "rootUri": "file:///Users/vanlooverenkoen/.pub-cache/hosted/pub.dartlang.org/yaml-3.1.0",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    },
    {
      "name": "license_generator",
      "rootUri": "../",
      "packageUri": "lib/",
      "languageVersion": "2.12"
    }
  ],
  "generated": "2021-12-31T11:41:40.795166Z",
  "generator": "pub",
  "generatorVersion": "2.14.3"
}
''';
      final json = jsonDecode(packageConfigJson) as Map<String, dynamic>;
      final result = PackageConfig.fromJson(json);
      expect(result.packages.length, 150);
    });
  });
}
