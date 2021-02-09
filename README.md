# flutter icapps license

A dart package to download the licenses for al the packages used.

[![pub package](https://img.shields.io/pub/v/icapps_license.svg)](https://pub.dartlang.org/packages/icapps_license)

## Setup

### Add dependency to pubspec

[![pub package](https://img.shields.io/pub/v/icapps_license.svg)](https://pub.dartlang.org/packages/icapps_license)
```
dev-dependencies:
  icapps_license: <latest-version>
```

### Basic options
```yaml
icapps_license:
  failFast: true    #Errors are not ignored and the generator will fail with an error
  nullsafety: true  #Generate nullsafe code
```

### Run package with Flutter

```
flutter packages pub run icapps_license
```

### Run package with Dart

```
pub run icapps_license
```

### Working on mac?

add this to you .bash_profile

```
flutterlicense(){
 flutter packages get && flutter packages pub run icapps_license
}
```

now you can use the icapps license with a single command.

```
flutterlicense
```