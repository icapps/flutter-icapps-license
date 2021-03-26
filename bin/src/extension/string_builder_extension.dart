extension StringBuilderExtension on StringBuffer {
  void writelnWithQuotesOrNull(String key, String? value) {
    if (value == null) {
      writeln('        $key: null,');
    } else {
      writeln('        $key: \'$value\',');
    }
  }
}
