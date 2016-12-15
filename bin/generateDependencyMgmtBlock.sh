#!/bin/bash

if [ -z "$GRAILS_CMD" ]; then
  GRAILS_CMD=grails
fi
if [ -z "$EXPECTED_GRAILS_VERSION" ]; then
  EXPECTED_GRAILS_VERSION=2.5.5
fi

REAL_GRAILS_VERSION=`$GRAILS_CMD --version|cut -d" " -f3`

if [ "$REAL_GRAILS_VERSION" != "$EXPECTED_GRAILS_VERSION" ]
then
  echo >&2 "$GRAILS_CMD is reporting version $REAL_GRAILS_VERSION but we expected $EXPECTED_GRAILS_VERSION.  Exiting."
  exit 1
fi

TMP_DIR=`mktemp -d`

current_dir=`pwd`

cd "$TMP_DIR"
$GRAILS_CMD create-app dummy-app
$GRAILS_CMD create-plugin dummy-plugin

(cd dummy-app; $GRAILS_CMD dependency-report > dependencies.txt)
(cd dummy-plugin; $GRAILS_CMD dependency-report > dependencies.txt)

cat $TMP_DIR/dummy-app/dependencies.txt $TMP_DIR/dummy-plugin/dependencies.txt | egrep "^.--" | sort | uniq | awk '{print "        dependency \"" $2 "\""}'

rm -rf $TMP_DIR

cd "$current_dir"
