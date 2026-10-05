# Solution Guide

## Observe Symptom

curl http://nginx/login

Returns:

{
  "error":"authentication unavailable"
}

---

## Verify Container Health

docker ps

All containers running.

---

## Check Auth Service

docker logs clab-ecommerce-auth

Observe:

password authentication failed

---

## Verify PostgreSQL

docker exec -it clab-ecommerce-postgres bash

psql -U appuser -d ecommerce

Authentication fails.

---

## Root Cause

Database password was changed.

---

## Fix

docker exec clab-ecommerce-postgres \
psql -U postgres \
-c "ALTER USER appuser PASSWORD 'password123';"

---

## Verify

curl http://nginx/login

Expected:

{
  "message":"login successful"
}

---

## Run Evaluator

./evaluator.sh

PASS
``