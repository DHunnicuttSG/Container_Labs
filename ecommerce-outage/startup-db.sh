#!/bin/sh

ip addr add 10.20.20.10/24 dev eth1
ip link set eth1 up

ip route add default via 10.20.20.1

docker-entrypoint.sh postgres