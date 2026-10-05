# E-Commerce Outage Investigation

## Scenario

You are a Production Support Engineer.

Business users report:

- Homepage available
- Login failing
- Orders failing

Priority: P2

You must restore service before the SLA breach.

---

## Learning Objectives

- Log Analysis
- Service Validation
- Database Troubleshooting
- Connectivity Testing
- Incident Management
- Root Cause Analysis

---

## Deploy

containerlab deploy -t support.clab.yml

---

## Inject Failure

./inject.sh

---

## Available Tools

- curl
- ping
- nslookup
- dig
- ss
- netstat
- tcpdump
- docker logs

---

## Success Criteria

Users can successfully log in.

---

## Evaluator

./evaluator.sh