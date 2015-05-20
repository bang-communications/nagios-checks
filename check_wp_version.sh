#!/bin/bash

# check_wp_version
# Read the file wp-includes/version.php to make sure WordPress is up to date.
# This relies on your sites being stored in a regular location on disk.


SITE="$1"
if [ -z "$SITE" ]; then
	echo "Include a domain name"
	exit 3 # unknown
fi

# Note: this is the first version NOT to mark as a Warning or Critical
WARNING_VERSION="4.2.2"
CRITICAL_VERSION="4.1.2"

cmp_version() {
	A="$1"
	B="$2"

	A1="$(echo "$A" | cut -d '.' -f 1)"
	A2="$(echo "$A" | cut -d '.' -f 2)"
	A3="$(echo "$A" | cut -d '.' -f 3)"
	B1="$(echo "$B" | cut -d '.' -f 1)"
	B2="$(echo "$B" | cut -d '.' -f 2)"
	B3="$(echo "$B" | cut -d '.' -f 3)"

	if [ "$A1" -lt "$B1" ]; then return 1; fi
	if [ "$A1" -eq "$B1" -a "$A2" -lt "$B2" ]; then return 1; fi
	if [ "$A1" -eq "$B1" -a "$A2" -eq "$B2" -a "$A3" -lt "$B3" ]; then return 1; fi

	return 0
}

HTDOCS=/var/www/"$SITE"/htdocs
if [ -e "$HTDOCS" ]; then
	if [ ! -e "$HTDOCS"/wp-includes/version.php ]; then
		echo "Does not appear to be a WordPress site"
		exit 3 # unknown
	fi

	VERSION="$(cat "$HTDOCS"/wp-includes/version.php | grep 'wp_version =' | grep -o '[0-9.]\+')"
	if [ -z "$VERSION" ]; then
		echo "Unable to determine version";
		exit 3 # unknown
	fi

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
