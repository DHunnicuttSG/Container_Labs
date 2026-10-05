#!/bin/bash

RESULT=$(docker exec clab-ecommerce-client curl -s http://nginx/login)

echo "$RESULT"

echo "$RESULT" | grep -q "login successful"

if [ $? -eq 0 ]
then
    echo "PASS"
else
    echo "FAIL"
fi
``