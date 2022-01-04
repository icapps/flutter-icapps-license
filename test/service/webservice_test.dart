import 'package:test/test.dart';
import '../../bin/src/service/webservice.dart';
import '../../bin/src/model/exception/fatal_exception.dart';

void main() {
  group('Test Webservice', () {
    test('test simpel get', () async {
      const webservice = WebService();
      final result = await webservice.get('https://pub.dev/api/packages/icapps_license/versions/1.0.0');
      expect(result,
          '{"version":"1.0.0","pubspec":{"name":"icapps_license","description":"Dart tool to generate a file that contains all licenses of the third party libraries","version":"1.0.0","homepage":"https://github.com/icapps/flutter-icapps-license","environment":{"sdk":">=2.12.0 <3.0.0"},"dependencies":{"http":"^0.13.0","path":"^1.8.0","yaml":"^3.1.0"},"dev_dependencies":{"test":"^1.16.5"}},"archive_url":"https://pub.dartlang.org/packages/icapps_license/versions/1.0.0.tar.gz","published":"2021-03-04T16:45:46.440798Z"}');
    });
    test('test simpel get non existing version', () async {
      const webservice = WebService();
      const url = 'https://pub.dev/api/packages/icapps_license/versions/1.0.014545';
      expect(
        () async => webservice.get(url),
        throwsA(predicate(
            (e) => e is FatalException && e.message == "Failed to get $url")),
      );
    });
  });
}
