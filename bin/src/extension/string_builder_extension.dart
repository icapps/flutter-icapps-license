extension StringBuilderExtension on StringBuffer {
  void writelnWithQuotesOrNull(String key, String? value) {
    if (value == null) {
      writeln('        $key: null,');
    } else if (value.contains("'")) {
      writeln("        $key: r\"$value\",");
    } else {
      writeln("        $key: r'$value',");
    }
  }
}
