#!/bin/bash
USER=$1
sudo sed -E -i '' -e 's/user =.*/user = '$USER'/g' '/etc/supervisor/conf.d/ocpizza-gunicorn.conf'
echo "Changed user to $USER"