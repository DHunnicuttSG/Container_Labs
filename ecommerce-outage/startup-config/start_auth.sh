#!/bin/bash

echo "Waiting for PostgreSQL..."

sleep 15

pip install flask psycopg2-binary

python /app/auth_server.py