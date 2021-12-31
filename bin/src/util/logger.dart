// ignore_for_file: avoid_print

import 'package:meta/meta.dart';

@immutable
class Logger {
  static var _logInfo = true;
  static var _logDebug = false;
  static var _logVerbose = false;

  const Logger._();

  static void init(String flag) {
    switch (flag) {
      case 'info':
        _logInfo = true;
        break;
      case 'debug':
        _logInfo = true;
        _logDebug = true;
        break;
      case 'verbose':
        _logInfo = true;
        _logDebug = true;
        _logVerbose = true;
        break;
    }
  }

  static void logInfo(dynamic message) {
    if (_logInfo) {
      print(message);
    }
  }

  static void logDebug(dynamic message) {
    if (_logDebug) {
      print(message);
    }
  }

  static void logVerbose(dynamic message) {
    if (_logVerbose) {
      print(message);
    }
  }

  static void logError(dynamic error) {
    if (_logDebug) {
      print(error);
    }
  }

  static void logStacktrace(StackTrace trace) {
    if (_logDebug) {
      print(trace);
    }
  }
}
