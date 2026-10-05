#!/bin/bash

INCIDENT=$((RANDOM % 5 + 1))

echo "Incident $INCIDENT selected"

case $INCIDENT in

1)

echo "DB password mismatch"

docker exec clab-ecommerce-postgres \
psql -U appuser -d ecommerce \
-c "ALTER USER appuser PASSWORD 'brokenpass';"

;;

2)

echo "Postgres stopped"

docker stop clab-ecommerce-postgres

;;

3)

echo "Auth service overloaded"

docker exec -d clab-ecommerce-auth \
bash -c "yes > /dev/null"

;;

4)

echo "Firewall block"

docker exec clab-ecommerce-auth \
iptables -A OUTPUT -p tcp --dport 5432 -j DROP

;;

5)

echo "Broken nginx config"

docker exec clab-ecommerce-nginx \
sed -i 's/auth:5000/fakehost:5000/' \
/etc/nginx/nginx.conf

docker exec clab-ecommerce-nginx nginx -s reload

;;

esac

echo "$INCIDENT" > .incident