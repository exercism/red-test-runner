#!/bin/sh

# Arguments:
# $1: `slug` - the exercise slug, e.g. `two-fer` (currently ignored)
# $2: `input_dir` - the path containing the solution to test (witho trailing slash and without preceeding ./)
# $3: `output_dir` - the output path for the test results path (with trailing slash and without preceeding ./)

# Example:
# ./run.sh two-fer path/to/two-fer/ path/to/output/directory/
# ./run.sh two-fer twofer/ outdir/

cd "$2" || exit
/bin/red /opt/test-runner/test-runner.red "$1" "$2" "$3"
