#!/bin/sh

COMMAND="$1"
MAXAGE=86400

# check a temporary file based on the command
TMP="/tmp/nagios-regular-$(echo "$COMMAND" | md5sum | cut -c 1-8)"
TMP_LOCK="$TMP".lock
TMP_OUTPUT="$TMP".log
TMP_RETURN="$TMP".return

if [ -f "$TMP_OUTPUT" ]; then
  AGE="$(($(date +%s) - $(date +%s -r "$TMP_OUTPUT")))"
  if [ "$AGE" -lt "$MAXAGE" ]; then
    OUTPUT="$(cat "$TMP_OUTPUT")"
    RETURN="$(cat "$TMP_RETURN")"

    echo "$OUTPUT"
    exit "$RETURN"
  fi
fi


# run the test, unless it's running in the background
if [ ! -e "$TMP_LOCK" ]; then
  OUTPUT="$(timeout 0.1s "$COMMAND")"
  RETURN="$?"
else
  echo "Task lock found"
  exit 3
fi


# if necessary, run this command again in the background
firecommand () {
  COMMAND="$1"
  TMP="$2"
  #TMP="/tmp/nagios-regular-$(echo "$COMMAND" | md5sum | cut -c 1-8)"
  TMP_LOCK="$TMP".lock
  TMP_OUTPUT="$TMP".log
  TMP_RETURN="$TMP".return

  touch "$TMP_LOCK"
  OUTPUT="$("$COMMAND")"
  RETURN="$?"
  rm "$TMP_LOCK"

  echo "$OUTPUT" > "$TMP_OUTPUT"
  echo "$RETURN" > "$TMP_RETURN"
}

if [ "$RETURN" = "124" ]; then
  RETURN=3

  if [ ! -e "$TMP_LOCK" ]; then
    firecommand "$COMMAND" "$TMP" &
  fi
else
  echo "$OUTPUT" > "$TMP_OUTPUT"
  echo "$RETURN" > "$TMP_RETURN"
fi

echo "$OUTPUT"
exit "$RETURN"
