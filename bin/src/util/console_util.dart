import 'dart:io';

import 'package:meta/meta.dart';

import 'logger.dart';

@immutable
class ConsoleUtil {
  static Stdin _stdin = stdin;

  const ConsoleUtil._();

  @visibleForTesting
  static void addStdin(Stdin stdin) {
    _stdin = stdin;
  }

  static bool readBoolean(String message) {
    String? result;
    while (result != 'y' && result != 'yes' && result != 'n' && result != 'no') {
      Logger.logInfo(message);
      result = _stdin.readLineSync()?.trim();
    }
    return result == 'y' || result == 'yes';
  }
}
