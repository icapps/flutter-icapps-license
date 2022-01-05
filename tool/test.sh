#!/bin/bash


dart run ./tool/test_coverage_helper.dart || exit -1;

rm -rf ./coverage

## Run Dart tests and output them at directory `./coverage`:
gtimeout 30 dart run test --coverage=./coverage

## Format collected coverage to LCOV (only for directory "lib")
format_coverage --packages=.packages --report-on=bin --lcov -o ./coverage/lcov.info -i ./coverage

## Generate LCOV report:
genhtml -o ./coverage/report ./coverage/lcov.info

## Open the HTML coverage report:
open ./coverage/report/index.html

rm test/coverage_helper_test.dart