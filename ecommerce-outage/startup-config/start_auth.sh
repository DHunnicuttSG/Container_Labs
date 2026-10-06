#!/bin/bash

ip addr add 10.20.20.30/24 dev eth1
ip link set eth1 up

pip install flask psycopg2-binary

sleep 15

python /app/auth_server.py