#!/bin/bash
VARIABLE_NAME=$1
VARIABLE_VALUE=$2

sudo sed -E -i '' -e 's/'$VARIABLE_NAME'="[^"]*/'$VARIABLE_NAME'="'$VARIABLE_VALUE/g'' '/etc/supervisor/conf.d/oc-pizza-gunicorn.conf'
echo "Changed $VARIABLE_NAME to $VARIABLE_VALUE"