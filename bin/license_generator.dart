// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'src/command/check_command.dart';
import 'src/command/generate_command.dart';
import 'src/model/exception/fatal_exception.dart';
import 'src/model/pubspec.dart';
import 'src/repo/license_repository.dart';
import 'src/service/config_service.dart';
import 'src/service/pubdev_webservice.dart';
import 'src/service/webservice.dart';
import 'src/util/logger.dart';

Future<void> main(List<String> args) async {
  try {
    if (args.isEmpty) {
      const message = 'license_generator should be started with `check` or `generate`';
      Logger.logInfo(message);
      throw FatalException(message);
    }

    final pubspecYaml = File(join(Directory.current.path, 'pubspec.yaml'));
    if (!pubspecYaml.existsSync()) {
      throw Exception('This program should be run from the root of a flutter/dart project');
    }

    final pubspecLockYaml = File(join(Directory.current.path, 'pubspec.lock'));
    if (!pubspecLockYaml.existsSync()) {
      throw Exception('pubspec.lock is missing. Make sure you run flutter packages get');
    }

    final pubspecContent = pubspecYaml.readAsStringSync();
    final pubspecLockContent = pubspecLockYaml.readAsStringSync();
    final params = Params(pubspecContent, pubspecLockContent);

    final command = args[0];
    if (args.length >= 2) {
      Logger.init(args[1]);
    } else {
      Logger.init('info');
    }
    const webservice = WebService();
    const configService = ConfigService();
    final _pubDevWebservice = PubDevWebservice(
      webservice: webservice,
      baseUrl: params.pubDevBaseUrlOverride ?? PubDevWebservice.defaultPubDevBaseUrl,
    );
    final licenseRepo = LicenseRepository(
      webservice,
      configService,
      _pubDevWebservice,
    );
    switch (command) {
      case 'check':
        CheckCommand.checkDependencies(params);
        break;
      case 'generate':
        await GenerateCommand(licenseRepo).generateLicenses(params);
        break;
    }
  } on FatalException {
    exit(-1);
  }
}
