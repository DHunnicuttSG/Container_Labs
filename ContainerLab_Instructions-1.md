# Production Support Networking Lab

## Production Support / SRE Fundamentals

### Objective

In this lab, students will build and troubleshoot a small network running on a single AWS EC2 instance using ContainerLab and Docker containers.

Students will learn how to:

* Verify network connectivity
* Troubleshoot DNS issues
* Troubleshoot routing issues
* Troubleshoot firewall issues
* Investigate application failures
* Capture network traffic
* Use common Linux networking commands used by Production  Support Engineers, NOC Analysts, SREs, and DevOps Engineers

## Scenario

You have joined the Production Support team for a company that runs a web application.

Users are reporting intermittent network issues and application outages.

Your job is to investigate and identify the root cause using Linux networking tools.

**Architecture**
```text
                    +---------+
                    | client  |
                    +---------+
                         |
                         |
                    +---------+
                    | router  |
                    +---------+
                    /        \
                   /          \
                  /            \
         +---------+      +---------+
         |  web1   |      |  dns1   |
         +---------+      +---------+
```

**Devices**
|Device|	Purpose|
|---|---|
|client|	End user workstation|
|router|	Network router|
|web1|	Web application server|
|dns1|	DNS server|

### Prerequisites

AWS EC2 Instance:
```bash
Amazon Linux 2023
t3.large
30 GB Storage
```

Open Security Group:
```bash
22 SSH
80 HTTP
50080 TCP
5001 TCP
```

## Part 1 - Environment Setup
### Step 1 Install Docker
```bash
sudo dnf update -y

sudo dnf install docker -y

sudo systemctl enable docker

sudo systemctl start docker
```

Verify:
```bash
docker ps
```

Expected:
```bash
CONTAINER ID   IMAGE   COMMAND
```

### Step 2 Add User to Docker Group
```bash
sudo usermod -aG docker ec2-user

newgrp docker
```

Verify:
```bash
docker ps
```

### Step 3 Install ContainerLab
```bash
bash -c "$(curl -sL https://get.containerlab.dev)"
```

Verify:
```bash
containerlab version
```

## Part 2 - Create the Lab

Create working directory:
```bash
mkdir network-lab

cd network-lab
```

Create topology file:

nano supportlab.clab.yml


**Paste** the following code into file:
```bash
name: supportlab

topology:
  nodes:

    client:
      kind: linux
      image: nicolaka/netshoot
      exec:
        - ip addr add 192.168.1.10/24 dev eth1
        - ip link set eth1 up
        - ip route replace default via 192.168.1.1

    router:
      kind: linux
      image: nicolaka/netshoot
      exec:
        - ip addr add 192.168.1.1/24 dev eth1
        - ip addr add 10.10.10.1/24 dev eth2
        - ip addr add 172.16.1.1/24 dev eth3
        - ip link set eth1 up
        - ip link set eth2 up
        - ip link set eth3 up
        - sysctl -w net.ipv4.ip_forward=1

    web1:
      kind: linux
      image: nicolaka/netshoot
      ports:
        - 80:80
      exec:
        - apk add nginx
        - nginx
        - ip addr add 10.10.10.10/24 dev eth1
        - ip link set eth1 up
        - ip route replace default via 10.10.10.1

    dns1:
      kind: linux
      image: nicolaka/netshoot
      exec:
        - ip addr add 172.16.1.10/24 dev eth1
        - ip link set eth1 up
        - ip route replace default via 172.16.1.1

  links:
    - endpoints:
        - client:eth1
        - router:eth1

    - endpoints:
        - router:eth2
        - web1:eth1

    - endpoints:
        - router:eth3
        - dns1:eth1
```

## Part 3 - Deploy

### Deploy topology:
```bash
sudo containerlab deploy -t supportlab.clab.yml
```

Verify:
```bash
docker ps
```

Expected:
```bash
clab-supportlab-client
clab-supportlab-router
clab-supportlab-web1
clab-supportlab-dns1
```

## Part 4 - Access Nodes

Access client:
* These commands give you a bash shell on the devices

```bash
docker exec -it clab-supportlab-client bash
```

Access router:
```bash
docker exec -it clab-supportlab-router bash
```

Access web server:
```bash
docker exec -it clab-supportlab-web1 bash
```

Access doman name service:
```bash
docker exec -it clab-supportlab-dns1 bash
```

## Part 5 - Networking Commands Reference
* test these commands within the network.  
  (i.e use one of the commands above to login to the network)

```bash
Check IP Addresses
ip addr
```

Example:

eth0
172.20.20.10

View Routing Table
```bash
ip route
```

Example:

default via 172.20.20.1

Test Connectivity
```bash
ping 8.8.8.8

ping web1
```

DNS Lookup
```bash
nslookup web1

dig web1
```

View Listening Ports
```bash
ss -tulpn
```

Check Connections
```bash
netstat -an
```

Trace Packet Path
```bash
traceroute web1
```

Test Web Site
```bash
curl http://web1
```

Capture Packets
```bash
tcpdump -i eth0
```
## In Development - SKIP
Part 6 - Installing EdgeShark

Install docker compose(run each command separately):
```bash
sudo mkdir -p /usr/local/lib/docker/cli-plugins

sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
```
Verify:
```bash
docker compose version
```

Run this command and replace <YOUR_EC2_PUBLIC_IP> with your actual AWS instance public IP.
```bash
curl -sL https://github.com/siemens/edgeshark/raw/main/deployments/wget/docker-compose.yaml | DOCKER_DEFAULT_PLATFORM= HG_HOSTNAME=<YOUR_EC2_PUBLIC_IP> docker compose -f - up -d
```

### Go to your browser and link to: http://<your publicIP>:5001
* Click the refresh button on the right if you need
---


## LAB EXERCISE 1
### DNS Failure
### Scenario

Users cannot access the website using the hostname.

Inject Failure

Login to Client:
```bash
docker exec -it clab-supportlab-client sh
```

Break DNS:
```bash
echo "nameserver 192.168.100.100" > /etc/resolv.conf
```

User Reports
The website is down.

Investigation

Check:
```bash
cat /etc/resolv.conf
```

Check:
```bash
nslookup web1
```

Check:
```bash
dig web1
```

Questions
* What DNS server is configured?
* Is the DNS server reachable?
* What error message is returned?
* What is the root cause?

Fix
```bash
echo "nameserver 127.0.0.11" > /etc/resolv.conf
```
**This is the ip address of docker's internal dns name server**

Would this line work?
```bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```
**This is the ip address of the Google dns server**

Retest:

nslookup web1

## LAB EXERCISE 2
### Routing Failure
### Scenario

The web server cannot be reached.

Inject Failure

Remove default route from client container:
```bash
ip route delete default
```
Use web1's lab interface IP for testing. The hostname `web1` may resolve to its management-network address, which remains reachable without the client's default route.

Symptoms
```bash
ping 10.10.10.10
```

Fails.

Investigation

View routes:
```bash
ip route
```

Check interface:
```bash
ip addr
```

Run:
```bash
traceroute 10.10.10.10
```

Questions
* Is a default route present?
* Which network is unreachable?
* What should the default gateway be?

Fix

Example:
```bash
ip route replace default via 192.168.1.1
```

## LAB EXERCISE 3
### Firewall Blocking Port
### Scenario

Users can ping the web server but cannot access the website.

Inject Failure

On container web1:
```bash
iptables -A INPUT -p tcp --dport 80 -j DROP

# COMMAND EXPLANATION
# iptables is the command used for Linux firewalls
# -A INPUT = appends a rule to the input chain
#   Input is ANY traffic going to this machine
# -p tcp = only match tcp packets
# --dport 80 = destination port is 80
# -j DROP = jump to target and the target is DROP
# This command will silently drop any tcp packets going to port 80
```

Symptoms

Ping works:
```bash
ping 10.10.10.10
```

Fails:
```bash
curl http://10.10.10.10
```

Investigation

Check:
```bash
iptables -L -n
```

Check:
```bash
ss -tulpn
```

Questions
* Is nginx running?
* Is port 80 listening?
* Is a firewall blocking the connection?
* What rule is causing the issue?
* What happens if you use this rule: 
  * iptables -A INPUT -p tcp --dport 80 -j REJECT
* How would we allow traffic from only 192.168.1.1?

Fix
```bash
iptables -F
```

## LAB EXERCISE 4
### Web Service Failure
### Scenario

The server is reachable but the application is down.

Inject Failure

On web1:
```bash
nginx -s stop
```

Symptoms
```bash
curl http://10.10.10.10
```

Returns:

Connection refused

Investigation

Check:
```bash
ps -ef | grep nginx
```

Check:
```bash
ss -tulpn
```

Check:
```bash
curl localhost
```

Questions
* Is nginx running?
* Is port 80 listening?
* Is the network healthy?
* What is the actual root cause?

Fix
```bash
nginx
```

Verify:
```bash
curl localhost
```

## LAB EXERCISE 5
### Packet Capture Investigation
### Scenario

Users report intermittent connectivity problems.

Start Packet Capture
```bash
tcpdump -ni eth1 host 10.10.10.10 and tcp port 80 -w capture.pcap

# use this one for captureing readable packets
tcpdump -ni eth1 -s 0 -A 'host 10.10.10.10 and tcp port 80'
# use this one for capturing ALL traffic on web1
tcpdump -ni eth1 -s 0 -A 'host 10.10.10.10'
```

Open another terminal:
```bash
curl http://10.10.10.10
```

Observe

Look for:

* DNS Requests
* TCP SYN
* TCP SYN ACK
* TCP RST
* ICMP

*** You can use ctrl-c to stop the capture 

### Reading the capture file

Your capture is in a binary format which will make part of it unreadable.  You will need to decode this file before reading it.  
```bash
tcpdump -nn -vv -r capture.pcap > capture.txt
```

Questions
* Do you see TCP traffic?
* Is the TCP handshake completed?
* Are packets being dropped?
* Did the server send a reset?
