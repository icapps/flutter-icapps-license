import 'package:test/test.dart';
import '../../bin/src/util/logger.dart';

void main() {
  group('Test Logger', () {
    group('test impl', () {
      late TestLoggerImpl loggerImpl;

      setUp(() {
        loggerImpl = TestLoggerImpl();
        Logger.setLoggerImpl(loggerImpl);
      });

      test('test logger normal', () {
        expect(loggerImpl.lastMessage, null);
        Logger.logInfo('logInfo');
        expect(loggerImpl.lastMessage, 'logInfo');
        Logger.logError('logError');
        expect(loggerImpl.lastMessage, 'logInfo');
        Logger.logDebug('logDebug');
        expect(loggerImpl.lastMessage, 'logInfo');
        Logger.logVerbose('logVerbose');
        expect(loggerImpl.lastMessage, 'logInfo');
        final stackTrace = StackTrace.current;
        Logger.logStacktrace(stackTrace);
        expect(loggerImpl.lastMessage, 'logInfo');
      });

      test('test logger info', () {
        Logger.init('info');
        expect(loggerImpl.lastMessage, null);
        Logger.logInfo('logInfo');
        expect(loggerImpl.lastMessage, 'logInfo');
        Logger.logError('logError');
        expect(loggerImpl.lastMessage, 'logInfo');
        Logger.logDebug('logDebug');
        expect(loggerImpl.lastMessage, 'logInfo');
        Logger.logVerbose('logVerbose');
        expect(loggerImpl.lastMessage, 'logInfo');
        final stackTrace = StackTrace.current;
        Logger.logStacktrace(stackTrace);
        expect(loggerImpl.lastMessage, 'logInfo');
      });

      test('test logger debug', () {
        Logger.init('debug');
        expect(loggerImpl.lastMessage, null);
        Logger.logInfo('logInfo');
        expect(loggerImpl.lastMessage, 'logInfo');
        Logger.logError('logError');
        expect(loggerImpl.lastMessage, 'logError');
        Logger.logDebug('logDebug');
        expect(loggerImpl.lastMessage, 'logDebug');
        Logger.logVerbose('logVerbose');
        expect(loggerImpl.lastMessage, 'logDebug');
        final stackTrace = StackTrace.current;
        Logger.logStacktrace(stackTrace);
        expect(loggerImpl.lastMessage, stackTrace);
      });

      test('test logger verbose', () {
        Logger.init('verbose');
        expect(loggerImpl.lastMessage, null);
        Logger.logInfo('logInfo');
        expect(loggerImpl.lastMessage, 'logInfo');
        Logger.logError('logError');
        expect(loggerImpl.lastMessage, 'logError');
        Logger.logDebug('logDebug');
        expect(loggerImpl.lastMessage, 'logDebug');
        Logger.logVerbose('logVerbose');
        expect(loggerImpl.lastMessage, 'logVerbose');
        final stackTrace = StackTrace.current;
        Logger.logStacktrace(stackTrace);
        expect(loggerImpl.lastMessage, stackTrace);
      });
    });
    group('log to print', () {
      test('test logger normal', () {
        Logger.logInfo('logInfo');
        Logger.logError('logError');
        Logger.logDebug('logDebug');
        Logger.logVerbose('logVerbose');
        final stackTrace = StackTrace.current;
        Logger.logStacktrace(stackTrace);
      });

      test('test logger info', () {
        Logger.init('info');
        Logger.logInfo('logInfo');
        Logger.logError('logError');
        Logger.logDebug('logDebug');
        Logger.logVerbose('logVerbose');
        final stackTrace = StackTrace.current;
        Logger.logStacktrace(stackTrace);
      });

      test('test logger debug', () {
        Logger.init('debug');
        Logger.logInfo('logInfo');
        Logger.logError('logError');
        Logger.logDebug('logDebug');
        Logger.logVerbose('logVerbose');
        final stackTrace = StackTrace.current;
        Logger.logStacktrace(stackTrace);
      });

      test('test logger verbose', () {
        Logger.init('verbose');
        Logger.logInfo('logInfo');
        Logger.logError('logError');
        Logger.logDebug('logDebug');
        Logger.logVerbose('logVerbose');
        final stackTrace = StackTrace.current;
        Logger.logStacktrace(stackTrace);
      });
    });
  });
}

class TestLoggerImpl extends LoggerImpl {
  dynamic lastMessage;

  @override
  void log(dynamic message) {
    lastMessage = message;
  }
}
