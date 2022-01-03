import 'package:test/test.dart';
import '../../bin/src/util/logger.dart';
import '../../bin/src/util/console_util.dart';

void main() {
  group('Test Console Util', () {
    late TestLoggerImpl loggerImpl;

    setUp(() {
      loggerImpl = TestLoggerImpl();
      Logger.setLoggerImpl(loggerImpl);
      ConsoleUtil.clearTestMessages();
    });
    group('no', () {
      test('test console util with no', () {
        expect(loggerImpl.lastMessage, null);
        ConsoleUtil.addTestMessage('no');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, null);
        expect(result, false);
      });
      test('test console util with n', () {
        expect(loggerImpl.lastMessage, null);
        ConsoleUtil.addTestMessage('n');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, null);
        expect(result, false);
      });
    });
    group('yes', () {
      test('test console util with yes', () {
        expect(loggerImpl.lastMessage, null);
        ConsoleUtil.addTestMessage('yes');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, null);
        expect(result, true);
      });
      test('test console util with y', () {
        expect(loggerImpl.lastMessage, null);
        ConsoleUtil.addTestMessage('y');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, null);
        expect(result, true);
      });
    });
    group('wrong predefined message', () {
      group('yes', () {
        test('test console util with yes', () {
          expect(loggerImpl.lastMessage, null);
          ConsoleUtil.addTestMessage('something');
          ConsoleUtil.addTestMessage('yes');
          final result = ConsoleUtil.readBoolean('This is the message');
          expect(loggerImpl.lastMessage, 'This is the message');
          expect(result, true);
        });
        test('test console util with y', () {
          expect(loggerImpl.lastMessage, null);
          ConsoleUtil.addTestMessage('something');
          ConsoleUtil.addTestMessage('y');
          final result = ConsoleUtil.readBoolean('This is the message');
          expect(loggerImpl.lastMessage, 'This is the message');
          expect(result, true);
        });
      });
      group('no', () {
        test('test console util with no', () {
          expect(loggerImpl.lastMessage, null);
          ConsoleUtil.addTestMessage('something');
          ConsoleUtil.addTestMessage('no');
          final result = ConsoleUtil.readBoolean('This is the message');
          expect(loggerImpl.lastMessage, 'This is the message');
          expect(result, false);
        });
        test('test console util with n', () {
          expect(loggerImpl.lastMessage, null);
          ConsoleUtil.addTestMessage('something');
          ConsoleUtil.addTestMessage('n');
          final result = ConsoleUtil.readBoolean('This is the message');
          expect(loggerImpl.lastMessage, 'This is the message');
          expect(result, false);
        });
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
