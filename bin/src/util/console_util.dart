import 'dart:io';

import 'package:meta/meta.dart';

import 'logger.dart';

@immutable
class ConsoleUtil {
  static final _testMessage = <String>[];

  const ConsoleUtil._();

  @visibleForTesting
  static void addTestMessage(String message) {
    _testMessage.add(message);
  }

  @visibleForTesting
  static void clearTestMessages() {
    _testMessage.clear();
  }

  static bool readBoolean(String message) {
    String? result;
    if (_testMessage.isNotEmpty) {
      result = _testMessage.removeAt(0);
    }
    while (result != 'y' && result != 'yes' && result != 'n' && result != 'no') {
      Logger.logInfo(message);
      if (_testMessage.isNotEmpty) {
        result = _testMessage.removeAt(0);
      } else {
        result = stdin.readLineSync()?.trim();
      }
    }
    return result == 'y' || result == 'yes';
  }
}
