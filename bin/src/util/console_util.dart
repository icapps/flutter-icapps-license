import 'dart:io';

import 'logger.dart';

class ConsoleUtil {
  static String? _testMessage;

  ConsoleUtil._();

  static void returnInTest(String message) {
    _testMessage = message;
  }

  static bool readBoolean(String message) {
    if (_testMessage != null) return _testMessage == 'y';
    String? result;
    while (result != 'y' && result != 'n') {
      Logger.logInfo(message);
      result = stdin.readLineSync()?.trim();
    }
    return result == 'y';
  }
}
