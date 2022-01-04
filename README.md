# flutter license_generator

A dart package to download the licenses for al the packages used.

[![pub package](https://img.shields.io/pub/v/license_generator.svg)](https://pub.dartlang.org/packages/license_generator)

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
  fail_fast: true    #Errors are not ignored and the generator will fail with an error
```

### Run package with Flutter

```
flutter packages pub run license_generator
```

### Run package with Dart

### Check if all versions in your pubspec.yaml match your pubspec.lock

```
pub run license_generator check
```

#### Generate the license file

```
pub run license_generator generate
```

### Logs

Info is the default and is not required to pass.
```
pub run license_generator generate

is the same as

pub run license_generator generate info
```

Debug will log more info te find out why the license_generator is failing. Stacktraces & errors will be shown. Info logs will also be shown.
```
pub run license_generator generate debug
```

Verbose will log everything. Downloading files & their status. Debug & info will also be shown.
```
pub run license_generator generate verbose
```

### Working on mac?

add this to you .bash_profile

```
flutterlicensecheck(){
 flutter packages get && flutter packages pub run license_generator check
}
```

```
flutterlicense(){
 flutter packages get && flutter packages pub run license_generator generate
}
```

now you can use the license_generate with a single command.

```
flutterlicense
```

And to check if everything is up to date use:
```
flutterlicensecheck
```