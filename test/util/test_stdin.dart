import 'dart:convert';

import 'dart:io';

abstract class TestStdin implements Stdin {
  void addInputString(String string);
}

class TestStdinSync implements TestStdin {
  final messages = <String>[];

  @override
  void addInputString(String string) {
    messages.add(string);
  }

  @override
  String? readLineSync({Encoding encoding = systemEncoding, bool retainNewlines = false}) {
    if (messages.isEmpty) return null;
    return messages.removeAt(0);
  }

  @override
  bool get isBroadcast => false;

  @override
  void noSuchMethod(Invocation invocation) {
    throw StateError('Unexpected invocation ${invocation.memberName}.');
  }
}
