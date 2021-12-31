// ignore_for_file: avoid_print

class Logger {
  static var _logDebug = false;
  static var _logVerbose = false;

  Logger.init(String flag) {
    if (flag == 'debug') {
      _logDebug = true;
    } else if (flag == 'verbose') {
      _logDebug = true;
      _logVerbose = true;
    }
  }

  static void logInfo(dynamic message) {
    print(message);
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
