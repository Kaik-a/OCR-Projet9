#!/bin/bash
SQL_PASSWORD=$1
HOST=$2
USER=$3
CLIENT_SECRET_KEY="secret_key_we_gave_to_client"

echo "Installing python"
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install python3.8

echo "Initializing venv"
python3.8 -m venv /etc/oc-pizza/venv

echo "Activate venv"
source /etc/oc-pizza/bin/activate

echo "Installing requirements"
pip install -r /etc/oc-pizza/requirements.txt

echo "Exporting variables"
export PATH=$PATH:/etc/oc-pizza/venv
export NEW_RELIC_CONFIG_FILE='/etc/oc-pizza/newrelic.ini'
export SQL_PASSWORD=$SQL_PASSWORD
export SECRET_KEY=$CLIENT_SECRET_KEY
export DJANGO_SETTINGS_MODULE='settings.production'
export HOST=$HOST

echo "Installing supervisor"
sudo apt-get install supervisor

echo "Writing supervisor conf file"
echo "[program:ocpizza-gunicorn]
command = /etc/oc-pizza/venv/bin/newrelic-admin run-program /etc-ocpizza/venv/bin/gunicorn ocpizza.wsgi
user = $USER
directory = /etc/oc-pizza/
autostart = true
autorestart = true
environment = NEW_RELIC_CONFIG_FILE='/etc/oc-pizza/newrelic.ini',SQL_PASSWORD=$SQL_PASSWORD,SECRET_KEY=$CLIENT_SECRET_KEY,DJANGO_SETTINGS_MODULE='settings.production',HOST=$HOST, PATH=$PATH:/etc/oc-pizza/venv
stderr_events_enabled = true
redirect_stderr = true
stdout_logfile = /etc/oc-pizza/logs/gunicorn.log
stderr_logfile = /etc/oc-pizza/logs/gunicorn_err.log" > /etc/supervisor/conf.d/ocpizza-gunicorn.conf

echo "Launching supervisor"
sudo supervisorctl update