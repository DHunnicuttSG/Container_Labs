#!/bin/bash

for br in frontend backend
do
    if ! ip link show "$br" >/dev/null 2>&1
    then
        sudo ip link add "$br" type bridge
        sudo ip link set "$br" up
        echo "Created bridge $br"
    else
        echo "Bridge $br already exists"
    fi
done
