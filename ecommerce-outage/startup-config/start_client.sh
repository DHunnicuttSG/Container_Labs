#!/bin/bash

ip addr add 10.10.10.10/24 dev eth1
ip link set eth1 up

tail -f /dev/null
