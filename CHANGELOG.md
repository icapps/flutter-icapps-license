# Changelog

## [3.0.0] - 2021-12-30
### Breaking
- Renamed this package from icapps_license to license_generator
- Completely refactored this package
- removed nullsafe flag
- license_url (because local licenses are used.)
### Added
- 2 commands
    - `check` to check if your pubspec.yaml versions match with your pubspec.lock versions
    - `generate` to generate the license dart file
- `checkBeforeGenerate` to run the check command before generate. default = false
- `downloadPubDevDetails` to get the homepage or repository in the url. default = false
- `usePubDevZH` to download the pub.dev details from https://pub.flutter-io.cn/ instead of https://pub.dev/. default = false

## [2.0.0] - 2021-03-26
### Breaking
-Version & LicenseUrl can return null from now on
### Added
-Support for importing extra dependencies that are not included in the pubspec. (Android or iOS specific code for example)
-Nullsafe flag again
-Stric mode codebase
### Fixed
-Example android v2 embedding
-Example android x migration

## [1.1.1] - 2021-03-07
### Fixed
-Required url in License object

## [1.1.0] - 2021-03-07
### Removed
-Nullsafe flag

## [1.0.1] - 2021-03-07
### Fixed
-Nullsafe code migration with nullabel homepage & repository

## [1.0.0] - 2021-03-04
### Added
-Nullsafe code migration stable release

## [1.0.0-nullsafety.0] - 2021-03-04
### Added
-Nullsafe code migration

## [0.0.8] - 2021-02-09
### Fixed
-Fixed crash if `licenses` was not set in yaml

## [0.0.7] - 2021-02-09
### Added
-Support generating code with nullsafety

## [0.0.6] - 2020-01-08
### Fixed
-False positive when a repository is defined

## [0.0.5] - 2020-01-08
### Added
-Url to pub.dev to make sure it is easy to find missing licenses

## [0.0.4] - 2020-01-08
### Added
-Better docs en example

## [0.0.3] - 2020-01-08
### Fixed
-Fixed a null pointer exception

## [0.0.2] - 2020-01-08
### Fixed
-Fixed a bug where the repository was never used to detect the license

## [0.0.1] - 2020-01-07
### Added
-Initial release
