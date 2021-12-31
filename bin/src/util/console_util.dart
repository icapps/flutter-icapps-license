import 'dart:io';

import 'package:meta/meta.dart';

import 'logger.dart';

@immutable
class ConsoleUtil {
  static String? _testMessage;

  const ConsoleUtil._();

  static void returnInTest(String message) {
    _testMessage = message;
  }

  static bool readBoolean(String message) {
    var result = _testMessage;
    while (result != 'y' && result != 'yes' && result != 'n' && result != 'no') {
      Logger.logInfo(message);
      result = stdin.readLineSync()?.trim();
    }
    return result == 'y' || result == 'yes';
  }
}
