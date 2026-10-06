#!/bin/bash

ip addr add 10.20.20.40/24 dev eth1

ip link set eth1 up

pip install flask

python /app/order_server.py