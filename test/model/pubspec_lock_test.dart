import 'package:test/test.dart';
import '../../bin/src/model/pubspec_lock.dart';
import '../../bin/src/model/exception/fatal_exception.dart';

void main() {
  group('Test PubspecLock', () {
    test('Test parsing without packages', () {
      const lock = r'''
test: test
''';
      expect(
        () => PubspecLock(lock),
        throwsA(predicate((e) => e is FatalException && e.message == 'Did you forget to run flutter packages get')),
      );
    });
  });
}
