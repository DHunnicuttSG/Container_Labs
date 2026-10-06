#!/bin/bash

ip addr add 10.10.10.20/24 dev eth1

ip addr add 10.20.20.20/24 dev eth2

ip link set eth1 up
ip link set eth2 up

sysctl -w net.ipv4.ip_forward=1

sleep 15

nginx -g 'daemon off;'