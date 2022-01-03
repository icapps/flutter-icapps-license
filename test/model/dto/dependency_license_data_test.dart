import 'package:test/test.dart';
import '../../../bin/src/model/dto/dependency_license_data.dart';

void main() {
  group('Test Dependency', () {
    test('Test dependency parsing', () {
      const data = DependencyLicenseData(
        license: 'this is my license',
        homepageUrl: 'this is the home url',
        repositoryUrl: 'this is the repo url',
      );
      expect(data.license, 'this is my license');
      expect(data.homepageUrl, 'this is the home url');
      expect(data.repositoryUrl, 'this is the repo url');
    });

    test('Test dependency license data with null data', () {
      const data = DependencyLicenseData(
        license: 'this is my license',
      );
      expect(data.license, 'this is my license');
      expect(data.homepageUrl, null);
      expect(data.repositoryUrl, null);
    });
  });
}
