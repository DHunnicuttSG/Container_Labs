#!/bin/bash

echo "Running Evaluation"

curl -s http://localhost/login | grep "login successful"

if [ $? -eq 0 ]
then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit 1
fi