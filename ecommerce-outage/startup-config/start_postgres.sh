#!/bin/bash

ip addr add 10.20.20.50/24 dev eth1
ip link set eth1 up

exec docker-entrypoint.sh postgres
