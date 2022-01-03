import 'package:test/test.dart';
import '../../bin/src/util/logger.dart';
import '../../bin/src/util/console_util.dart';
import 'test_stdin.dart';

void main() {
  group('Test Console Util', () {
    late TestLoggerImpl loggerImpl;
    late TestStdin stdin;

    setUp(() {
      loggerImpl = TestLoggerImpl();
      stdin = TestStdinSync();
      Logger.setLoggerImpl(loggerImpl);
      ConsoleUtil.setStdin(stdin);
    });

    group('no', () {
      test('test console util with no', () {
        expect(loggerImpl.lastMessage, null);
        stdin.addInputString('no');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, 'This is the message');
        expect(result, false);
      });
      test('test console util with n', () {
        expect(loggerImpl.lastMessage, null);
        stdin.addInputString('n');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, 'This is the message');
        expect(result, false);
      });
    });
    group('yes', () {
      test('test console util with yes', () {
        expect(loggerImpl.lastMessage, null);
        stdin.addInputString('yes');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, 'This is the message');
        expect(result, true);
      });
      test('test console util with y', () {
        expect(loggerImpl.lastMessage, null);
        stdin.addInputString('y');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, 'This is the message');
        expect(result, true);
      });
    });
    group('wrong predefined message', () {
      group('yes', () {
        test('test console util with yes', () {
          expect(loggerImpl.lastMessage, null);
          stdin.addInputString('something');
          stdin.addInputString('yes');
          final result = ConsoleUtil.readBoolean('This is the message');
          expect(loggerImpl.lastMessage, 'This is the message');
          expect(result, true);
        });
        test('test console util with y', () {
          expect(loggerImpl.lastMessage, null);
          stdin.addInputString('something');
          stdin.addInputString('y');
          final result = ConsoleUtil.readBoolean('This is the message');
          expect(loggerImpl.lastMessage, 'This is the message');
          expect(result, true);
        });
      });
      group('no', () {
        test('test console util with no', () {
          expect(loggerImpl.lastMessage, null);
          stdin.addInputString('something');
          stdin.addInputString('no');
          final result = ConsoleUtil.readBoolean('This is the message');
          expect(loggerImpl.lastMessage, 'This is the message');
          expect(result, false);
        });
        test('test console util with n', () {
          expect(loggerImpl.lastMessage, null);
          stdin.addInputString('something');
          stdin.addInputString('n');
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
