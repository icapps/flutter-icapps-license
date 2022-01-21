import 'dart:async';

import 'src/license_generator.dart';
import 'src/model/exception/fatal_exception.dart';
import 'src/util/logger.dart';

Future<void> main(List<String> args) async {
  try {
    final generator = LicenseGenerator(args);
    await generator.run();
  } on FatalException catch (e, trace) {
    Logger.logInfo('Failed to complete the license generator, because of $e');
    Logger.logError(e);
    Logger.logStacktrace(trace);
  }
}
