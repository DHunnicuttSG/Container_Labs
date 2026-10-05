#!/bin/bash

docker exec clab-ecommerce-postgres \
psql -U postgres \
-c "ALTER USER appuser PASSWORD 'password123';"

echo "Environment reset."
`