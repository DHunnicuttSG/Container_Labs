#!/bin/bash

ip addr add 10.20.20.10/24 dev eth1
ip addr add 10.40.40.1/24 dev eth2

ip link set eth1 up
ip link set eth2 up

pip install flask psycopg2-binary

sleep 15

python /app/auth_server.py