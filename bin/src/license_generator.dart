import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';

import 'command/check_command.dart';
import 'command/generate_command.dart';
import 'model/exception/fatal_exception.dart';
import 'model/pubspec.dart';
import 'repo/license_repository.dart';
import 'service/config_service.dart';
import 'service/pubdev_webservice.dart';
import 'service/webservice.dart';
import 'util/logger.dart';

final defaultPubspecPath = join(Directory.current.path, 'pubspec.yaml');
final defaultPubspecLockPath = join(Directory.current.path, 'pubspec.lock');

class LicenseGenerator {
  late final String _command;
  late final Params _params;
  late final CheckCommand _checkCommand;
  late final GenerateCommand _generateCommand;

  LicenseGenerator(
    List<String> args, {
    String? pubspecPath,
    String? pubspecLockPath,
  }) {
    if (args.isEmpty) {
      const message =
          'license_generator should be started with `check` or `generate`';
      Logger.logInfo(message);
      throw FatalException(message);
    }

    pubspecPath ??= defaultPubspecPath;
    pubspecLockPath ??= defaultPubspecLockPath;

    final pubspecYaml = File(pubspecPath);
    if (!pubspecYaml.existsSync()) {
      throw FatalException(
          'This program should be run from the root of a flutter/dart project');
    }

    final pubspecLockYaml = File(pubspecLockPath);
    if (!pubspecLockYaml.existsSync()) {
      throw FatalException(
          'pubspec.lock is missing. Make sure you run flutter packages get');
    }

    final pubspecContent = pubspecYaml.readAsStringSync();
    final pubspecLockContent = pubspecLockYaml.readAsStringSync();
    _params = Params(pubspecContent, pubspecLockContent);

    _command = args[0];
    if (args.length >= 2) {
      Logger.init(args[1]);
    } else {
      Logger.init('info');
    }
    const webservice = WebService();
    const configService = ConfigService();
    final pubDevWebservice = PubDevWebservice(
      webservice: webservice,
      baseUrl: _params.pubDevBaseUrlOverride ??
          PubDevWebservice.defaultPubDevBaseUrl,
    );
    final licenseRepo = LicenseRepository(
      webservice,
      configService,
      pubDevWebservice,
    );
    _checkCommand = const CheckCommand();
    _generateCommand = GenerateCommand(licenseRepo);
  }

  Future<void> run() async {
    switch (_command) {
      case 'check':
        _checkCommand.checkDependencies(_params);
        break;
      case 'generate':
        await _generateCommand.generateLicenses(_params);
        break;
    }
  }

  @visibleForTesting
  void overrideFileOuputPath(String path) {
    _params.fileOutputPath = path;
  }
}
