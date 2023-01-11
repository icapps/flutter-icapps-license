# Changelog

## [1.0.5] - 2022-10-24
### Fixed
- Analyzer

## [1.0.4] - 2022-10-24
### Added
- Better support for Windows (Thanks [stacew](https://github.com/stacew))
### Fixed
- Tests
### Updated
- Dependencies

## [1.0.3] - 2022-01-21
### Fixed
- always log a FatalException with a basic message. (debug or verbose should be used to see the full stacktrace.)

## [1.0.2] - 2022-01-05
### Improved
- changelog formatting

## [1.0.1] - 2022-01-05
### Improved
- readme documentation for `fail_fast`, `check_before_generate`, `download_pub_dev_details`.

## [1.0.0] - 2022-01-05
### Initial release
- This package is a full refactor of icapps_license
- icapps_license was renamed to license_generator
- removed nullsafe flag
- local licenses are used based on `.dart_tool/package_config.json`

### Added
- 2 commands
    - `check` to check if your pubspec.yaml versions match with your pubspec.lock versions
    - `generate` to generate the license dart file
- `checkBeforeGenerate` to run the check command before generate. default = false
- `downloadPubDevDetails` to get the homepage or repository in the url. default = false
- `pubDevBaseUrl` to download the pub.dev details from another baseUrl. default = https://pub.dev/
- support for extra logging default = `info`, but there is also `debug` and `verbose`
