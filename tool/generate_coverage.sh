#!/bin/bash
## Format collected coverage to LCOV (only for directory "lib")
format_coverage --packages=.packages --report-on=bin --lcov -o ./coverage/lcov.info -i ./coverage

## Generate LCOV report:
genhtml -o ./coverage/report ./coverage/lcov.info

## Open the HTML coverage report:
open ./coverage/report/index.html

rm test/coverage_helper_test.dart