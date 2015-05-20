#!/bin/bash

# check_drupal_version
# Read the file includes/bootstrap.inc to make sure Drupal is up to date.
# This relies on your sites being stored in a regular location on disk.


SITE="$1"
if [ -z "$SITE" ]; then
	echo "Include a domain name"
	exit 3 # unknown
fi

WARNING_VERSION="7.36"
CRITICAL_VERSION="7.0"

cmp_version() {
	A="$1"
	B="$2"

	A1="$(echo "$A" | cut -d '.' -f 1)"
	A2="$(echo "$A" | cut -d '.' -f 2)"
	#A3="$(echo "$A" | cut -d '.' -f 3)"
	B1="$(echo "$B" | cut -d '.' -f 1)"
	B2="$(echo "$B" | cut -d '.' -f 2)"
	#B3="$(echo "$B" | cut -d '.' -f 3)"

	if [ "$A1" -lt "$B1" ]; then return 1; fi
	if [ "$A1" -eq "$B1" -a "$A2" -lt "$B2" ]; then return 1; fi
	#if [ "$A3" -lt "$B3" ]; then return 1; fi

	return 0
}

HTDOCS=/var/www/"$SITE"/htdocs
if [ -e "$HTDOCS" ]; then
	VERSION="$(cat "$HTDOCS"/includes/bootstrap.inc | grep "'VERSION'" | grep -p '[0-9].\+')"

	if ! cmp_version "$VERSION" "$CRITICAL_VERSION"; then
		echo "$VERSION < $CRITICAL_VERSION"
		exit 2 # critical
	fi
	if ! cmp_version "$VERSION" "$WARNING_VERSION"; then
		echo "$VERSION < $WARNING_VERSION"
		exit 1 # warning
	fi
	echo "$VERSION"
	exit 0 # OK
else
	echo "$HTDOCS not found"
	exit 3 # unknown
fi
