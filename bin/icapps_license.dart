import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'src/model/dto/dependency.dart';
import 'src/params.dart';

const baseUrl = 'https://pub.dev/api/packages/';
const urlVersionPath = '/versions/';
const licensePath = '/blob/master/LICENSE';

final outputFilePath = join('lib', 'util', 'license.dart');

Future<void> main(List<String> args) async {
  final pubspecYaml = File(join(Directory.current.path, 'pubspec.yaml'));
  if (!pubspecYaml.existsSync()) {
    throw Exception(
        'This program should be run from the root of a flutter/dart project');
  }

  final pubspecContent = pubspecYaml.readAsStringSync();
  final params = Params();
  await params.init(pubspecContent);

  final outputFile = File(outputFilePath);
  if (!outputFile.existsSync()) {
    outputFile.createSync(recursive: true);
  }

  final nullableFieldInfix = params.nullSafe ? '?' : '';

  final sb = StringBuffer()
    ..writeln(
        '//============================================================//')
    ..writeln('//THIS FILE IS AUTO GENERATED. DO NOT EDIT//')
    ..writeln(
        '//============================================================//')
    ..writeln()
    ..writeln('class License {')
    ..writeln('  final String name;')
    ..writeln('  final String version;')
    ..writeln('  final String$nullableFieldInfix url;')
    ..writeln('  final String licenseUrl;')
    ..writeln('  final String license;')
    ..writeln()
    ..writeln('  License({');
  if (params.nullSafe) {
    sb
      ..writeln('   required this.name,')
      ..writeln('   required this.version,')
      ..writeln('   required this.licenseUrl,')
      ..writeln('   required this.license,')
      ..writeln('   required this.url,');
  } else {
    sb
      ..writeln('   this.name,')
      ..writeln('   this.version,')
      ..writeln('   this.licenseUrl,')
      ..writeln('   this.license,')
      ..writeln('   this.url,');
  }
  sb
    ..writeln('  });')
    ..writeln('}')
    ..writeln()
    ..writeln('class LicenseUtil {')
    ..writeln('  LicenseUtil._();')
    ..writeln()
    ..writeln('  static List<License> getLicenses() {')
    ..writeln('    return <License>[]');

  params.dependencies.forEach((e) {
    sb.write(_getDependencyText(e));
  });

  params.devDependencies.forEach((e) {
    sb.write(_getDependencyText(e));
  });

  sb
    ..write(';')
    ..writeln('  }')
    ..writeln('}');

  outputFile.writeAsStringSync(sb.toString());

  Params.missingLicensesList.forEach(print);
  if (params.failFast &&
      Params.missingLicensesList.isNotEmpty &&
      Params.missingLicenses) {
    throw Exception('Failed to resolve all licenses');
  }
  print('DONE');
}

String _getDependencyText(Dependency dependency) {
  final sb = StringBuffer()
    ..writeln('      ..add(License(')
    ..writeln('        name: \'${dependency.name}\',')
    ..writeln('        version: \'${dependency.version}\',')
    ..writeln('        url: \'${dependency.url}\',')
    ..writeln('        licenseUrl: \'${dependency.licenseUrl}\',')
    ..writeln('        license: \'\'\'${dependency.license}\'\'\',')
    ..writeln('      ))');
  return sb.toString();
}
