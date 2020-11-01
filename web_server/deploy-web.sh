#!/bin/bash
DOMAIN_NAME_1=$1
DOMAIN_NAME_2=$2
IP=$3

echo "Adding the repository"
sudo add-apt-repository ppa:certbot/certbot

echo "Installing certbot"
sudo apt install python-certbot-nginx

echo "Creating conf for nginx"
echo "
server {
        server_name pur-beurre-mbi.site www.pur-beurre-mbi.site;
        root /etc/oc-pizza;

        location /staticfiles {
                alias /etc/oc-pizza/staticfiles/;
        }

        location /static {
                alias /etc/oc-pizza/staticfiles/;
}
        location / {
                proxy_set_header Host \$http_host;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_redirect off;
                if (!-f \$request_filename) {
                        proxy_pass http://$IP:8000;
                        break;
                }
        }
}" | sudo tee -a "/etc/nginx/sites-available/$1" > /dev/null

echo "Reloading nginx conf"
sudo systemctl reload nginx

sudo ln -s /etc/nginx/sites-available/"$DOMAIN_NAME_1" /etc/nginx/sites-enabled/

echo "Creating certificate and applicating to nginx conf"
sudo certbot --nginx -d "$DOMAIN_NAME_1" -d "$DOMAIN_NAME_2"


echo "Reloading nginx conf"
sudo systemctl reload nginx
