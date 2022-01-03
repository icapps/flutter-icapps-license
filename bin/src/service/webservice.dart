import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../util/logger.dart';

@immutable
class WebService {
  const WebService();

  Future<String> get(String url) async {
    Logger.logVerbose('Downloading: $url');
    final result = await http.get(Uri.parse(url));
    if (result.statusCode != 200) {
      Logger.logVerbose('Downloading failed: ${result.body}');
      throw Exception('Failed to get $url');
    }
    Logger.logVerbose('Downloading complete: $url');
    return result.body;
  }
}
