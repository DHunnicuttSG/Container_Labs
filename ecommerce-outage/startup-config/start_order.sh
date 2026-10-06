#!/bin/bash

ip addr add 10.30.30.10/24 dev eth1

ip link set eth1 up

pip install flask

python /app/order_server.py