# flutter license_generator

A dart package to download the licenses for al the packages used.

[![pub package](https://img.shields.io/pub/v/license_generator.svg)](https://pub.dartlang.org/packages/license_generator)
[![Build Status](https://app.travis-ci.com/icapps/flutter-icapps-license.svg?branch=master)](https://app.travis-ci.com/icapps/flutter-icapps-license)
[![Coverage Status](https://coveralls.io/repos/github/icapps/flutter-icapps-license/badge.svg)](https://coveralls.io/github/icapps/flutter-icapps-license)

## Setup

### Add dependency to pubspec

[![pub package](https://img.shields.io/pub/v/license_generator.svg)](https://pub.dartlang.org/packages/license_generator)
```
dev-dependencies:
  license_generator: <latest-version>
```

### Basic options
```yaml
license_generator:
  fail_fast: true/false    #(optional) Errors are not ignored and the generator will fail with an error
```

### All options
```yaml
license_generator:
  fail_fast: boolean #(optional) if true the `check` command will fail at the first version missmatch. If false you will receive a list at the end of the command. -> Default: false
  check_before_generate: boolean #(optional) If true the `generate` command will check if your pubspec.yaml & pubspec.lock are in sync before generating the code -> Default: false
  output_path: String #(optional) Override the default output path to generate the license file somewhere else -> Default: lib/util/license.dart
  download_pub_dev_details: bool #(optional) If ture the `generate` command will download the pubdev details (homepage/repository) -> Default: false
  pub_dev_base_url: String #(optional) This will override the default pubdev base url for downloading the pubdev details (homepage/repository) -> Default: https://pub.dev
  licenses: #(optional) This will accept key value pairs (String/String) -> (package name/raw license url)
    #license_generator: https://raw.githubusercontent.com/icapps/flutter-icapps-license/master/LICENSE (example)
  ignore_licenses: #(optional) This wil accept a list of package names (String)
    - shared_preferences
  extra_licenses: #(optional) this will allow you to add extra licenses that are not added in your pubspec.yaml
    something_something: #the name of your package will be used if `name` is not specified
      name: String #(optional) This will override your package name
      version: String #(optional) The version of this specific package/license
      homepage: String #(optional) The url of the homepage of this package
      repository: String #(optional) The url where the repository is located
      license: String #(required) This can be an http/https url or a path to a specific file. The content of that url/path will be used to generate code.
      dev_dependency: boolean #(optional) This is used internally
      part_of_flutter_sdk: boolean #(optional) This will use the flutter license instead of the license specified in this map
```

### Run package with Flutter

```bash
flutter packages pub run license_generator
```

### Run package with Dart

### Check if all versions in your pubspec.yaml match your pubspec.lock

```bash
pub run license_generator check
```

#### Generate the license file

```bash
pub run license_generator generate
```

### Logs

Info is the default and is not required to pass.
```bash
pub run license_generator generate

is the same as

pub run license_generator generate info
```

Debug will log more info te find out why the license_generator is failing. Stacktraces & errors will be shown. Info logs will also be shown.
```bash
pub run license_generator generate debug
```

Verbose will log everything. Downloading files & their status. Debug & info will also be shown.
```bash
pub run license_generator generate verbose
```

### Working on mac?

add this to you .bash_profile

```bash
flutterlicensecheck(){
 flutter packages get && flutter packages pub run license_generator check
}
```

```bash
flutterlicense(){
 flutter packages get && flutter packages pub run license_generator generate
}
```

now you can use the license_generate with a single command.

```bash
flutterlicense
```

And to check if everything is up to date use:
```bash
flutterlicensecheck
```