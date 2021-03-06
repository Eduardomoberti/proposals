#!/bin/bash

PHPCS_BIN=./vendor/bin/phpcs
PHPCS_CODING_STANDARD=Drupal,DrupalPractice

# simple check if code sniffer is set up correctly
if [ ! -x $PHPCS_BIN ]; then
    echo "No se encontró el ejecutable de Codesniffer -> $PHPCS_BIN"
    exit 1
fi

IN=$(git diff --name-only --staged --ignore-submodules --diff-filter=ACM | grep -v -e "modules/contrib\|modules/features")
IN2=$(echo ${IN/"\n"/' '})

if [ "$IN2" == "" ]; then
    exit 0
fi

OUTPUT=$($PHPCS_BIN --standard=$PHPCS_CODING_STANDARD $IN2)
RETVAL=$?

if [ $RETVAL -ne 0 ]; then
    echo "Revisa el código antes de commitear"
    echo "$OUTPUT"
fi

exit $RETVAL
