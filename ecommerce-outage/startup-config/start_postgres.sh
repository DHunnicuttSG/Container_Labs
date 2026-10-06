#!/bin/bash

ip addr add 10.40.40.10/24 dev eth1

ip link set eth1 up

exec docker-entrypoint.sh postgres
