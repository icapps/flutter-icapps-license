# Example for the license_generator

This will be generated.

```
//============================================================//
//THIS FILE IS AUTO GENERATED. DO NOT EDIT//
//============================================================//

class License {
  final String name;
  final String version;
  final String url;
  final String licenseUrl;
  final String license;

  License({
    this.name,
    this.version,
    this.url,
    this.licenseUrl,
    this.license,
  });
}

class LicenseUtil {
  LicenseUtil._();

  static List<License> getLicenses() {
    return List<License>()
      ..add(License(
        name: 'license_generator',
        version: '^0.0.3',
        url: 'https://github.com/icapps/flutter-icapps-license',
        licenseUrl: 'https://raw.githubusercontent.com/icapps/flutter-icapps-license/master/LICENSE',
        license: '''MIT License
                    
                    Copyright (c) 2019 icapps
                    
                    Permission is hereby granted, free of charge, to any person obtaining a copy
                    of this software and associated documentation files (the "Software"), to deal
                    in the Software without restriction, including without limitation the rights
                    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                    copies of the Software, and to permit persons to whom the Software is
                    furnished to do so, subject to the following conditions:
                    
                    The above copyright notice and this permission notice shall be included in all
                    copies or substantial portions of the Software.
                    
                    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                    SOFTWARE.''',
      ));
  }
}
```