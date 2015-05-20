#!/bin/sh

# check_warn
# A wrapper around other checks that turns errors into warnings.

# run the given command
$@
RESULT=$?
if [ $RESULT -eq 2 ]; then
	exit 1
fi
exit $RESULT
