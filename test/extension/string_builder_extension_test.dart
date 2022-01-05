import 'package:test/test.dart';
import '../../bin/src/extension/string_builder_extension.dart';

void main() {
  group('Test writelnWithQuotesOrNull', () {
    test('Test writelnWithQuotesOrNull with value', () {
      final sb = StringBuffer();
      sb.writelnWithQuotesOrNull('key', 'value');
      expect(sb.toString(), "        key: r'value',\n");
    });

    test('Test writelnWithQuotesOrNull with null', () {
      final sb = StringBuffer();
      sb.writelnWithQuotesOrNull('key', null);
      expect(sb.toString(), "        key: null,\n");
    });

    test('Test writelnWithQuotesOrNull with null', () {
      final sb = StringBuffer();
      sb.writelnWithQuotesOrNull('key', "'quoted value'");
      expect(sb.toString(), '        key: r"\'quoted value\'",\n');
    });
  });
}