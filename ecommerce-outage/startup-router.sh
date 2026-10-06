#!/bin/sh

ip addr add 10.10.10.1/24 dev eth1
ip addr add 10.20.20.1/24 dev eth2

ip link set eth1 up
ip link set eth2 up

sysctl -w net.ipv4.ip_forward=1

sleep infinity