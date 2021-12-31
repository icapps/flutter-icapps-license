import 'dart:io';

import 'logger.dart';

class ConsoleUtil {
  ConsoleUtil._();

  static bool readBoolean(String message) {
    String? result;
    while (result != 'y' && result != 'n') {
      Logger.logInfo(message);
      result = stdin.readLineSync()?.trim();
    }
    return result == 'y';
  }
}
