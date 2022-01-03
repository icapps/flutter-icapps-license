import 'dart:ffi';
import 'dart:io';

import 'package:test/test.dart';
import '../../bin/src/util/logger.dart';
import '../../bin/src/util/console_util.dart';

void main() {
  group('Test Console Util', () {
    late TestLoggerImpl loggerImpl;

    setUp(() {
      loggerImpl = TestLoggerImpl();
      Logger.setLoggerImpl(loggerImpl);
      ConsoleUtil.returnInTest(null);
    });
    group('no', () {
      test('test console util with no', () {
        expect(loggerImpl.lastMessage, null);
        ConsoleUtil.returnInTest('no');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, null);
        expect(result, false);
      });
      test('test console util with n', () {
        expect(loggerImpl.lastMessage, null);
        ConsoleUtil.returnInTest('n');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, null);
        expect(result, false);
      });
    });
    group('yes', () {
      test('test console util with yes', () {
        expect(loggerImpl.lastMessage, null);
        ConsoleUtil.returnInTest('yes');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, null);
        expect(result, true);
      });
      test('test console util with y', () {
        expect(loggerImpl.lastMessage, null);
        ConsoleUtil.returnInTest('y');
        final result = ConsoleUtil.readBoolean('This is the message');
        expect(loggerImpl.lastMessage, null);
        expect(result, true);
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
