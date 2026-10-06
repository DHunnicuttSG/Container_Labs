#!/bin/bash

ip addr add 10.10.10.1/24 dev eth1
ip addr add 10.20.20.1/24 dev eth2
ip addr add 10.30.30.1/24 dev eth3

ip link set eth1 up
ip link set eth2 up
ip link set eth3 up

sysctl -w net.ipv4.ip_forward=1

sleep 10

nginx -g 'daemon off;'