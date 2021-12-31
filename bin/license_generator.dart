// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'src/command/check.dart';
import 'src/command/generate.dart';
import 'src/model/pubspec.dart';
import 'src/util/logger.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('license_generator should be started with `check` or `generate`');
    exit(-1);
  }

  final pubspecYaml = File(join(Directory.current.path, 'pubspec.yaml'));
  if (!pubspecYaml.existsSync()) {
    throw Exception('This program should be run from the root of a flutter/dart project');
  }

  final pubspecLockYaml = File(join(Directory.current.path, 'pubspec.lock'));
  if (!pubspecLockYaml.existsSync()) {
    throw Exception('Make sure you run flutter packages get ');
  }

  final pubspecContent = pubspecYaml.readAsStringSync();
  final pubspecLockContent = pubspecLockYaml.readAsStringSync();
  final params = Params();
  await params.init(pubspecContent, pubspecLockContent);

  final command = args[0];
  if (args.length >= 2) {
    Logger.init(args[1]);
  }
  switch (command) {
    case 'check':
      CheckCommand.checkDependencies(params);
      break;
    case 'generate':
      await GenerateCommand.generateLicenses(params);
      break;
  }
  print('DONE');
}