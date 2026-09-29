# Creating a graph service for your labs

### Step 1: Verify the Graph Viewer Works

From your topology directory:
```bash
cd ~/labs

clab graph -t support.clab.yml --srv :50080
```

Open a browser:
```bash
http://SERVER-IP:50080
```

Press Ctrl+C when you've confirmed it works.

### Step 2: Find the Full Path to clab

Systemd should use absolute paths.
```bash
which clab
```

Example output:
```bash
/usr/local/bin/clab
```

Save this path. You'll use it in the service file.

### Step 3: Create a Dedicated Service File

Create:
```bash
sudo nano /etc/systemd/system/containerlab-graph.service
```

Paste:
```bash
[Unit]
Description=Containerlab Graph Viewer
After=network-online.target docker.service
Wants=network-online.target

[Service]
Type=simple

# Change this to your topology directory
WorkingDirectory=/home/ec2-user/labs

# Change the clab path if different
ExecStart=/usr/local/bin/clab graph -t supportlab.clab.yml --srv :50080

Restart=always
RestartSec=5

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Save and exit.

### Step 4: Reload systemd
```bash
sudo systemctl daemon-reload
```

### Step 5: Enable Service at Boot
```bash
sudo systemctl enable containerlab-graph.service
```

You should see:
```bash
Created symlink ...
```

### Step 6: Start the Service
```bash
sudo systemctl start containerlab-graph.service
```

### Step 7: Verify Status
```bash
sudo systemctl status containerlab-graph.service
```

You want to see:
```bash
Active: active (running)
```

## Troubleshooting
### Step 8: View Logs

Very useful for troubleshooting.
```bash
sudo journalctl -u containerlab-graph.service -f
```

Example:
```bash
Serving topology on :50080
```

### Step 9: Verify the Port is Listening
```bash
sudo ss -tulpn | grep 50080
```

Expected:
```bash
LISTEN 0 4096 *:50080
```

### Step 10: Open Firewall (if needed)
```bash
RHEL / Rocky / AlmaLinux:

sudo firewall-cmd --permanent --add-port=50080/tcp
sudo firewall-cmd --reload


Ubuntu:

sudo ufw allow 50080/tcp


AWS EC2:

Add an inbound rule:

TCP 50080
Source: Your IP or 0.0.0.0/0
```

### Useful Troubleshooting Commands
**Stop**
```bash
sudo systemctl stop containerlab-graph
```

**Start**
```bash
sudo systemctl start containerlab-graph
```

**Restart**
```bash
sudo systemctl restart containerlab-graph
```

**Disable**
```bash
sudo systemctl disable containerlab-graph
```

**Check Logs**
```bash
sudo journalctl -u containerlab-graph -n 50
```

**If the service won't start, run:**
```bash
sudo systemctl status containerlab-graph -l
```

**Wrong clab path**
```bash
which clab
```

**Update ExecStart= accordingly.**

**Wrong topology file location**
```bash
ls -l /home/ec2-user/network-lab/supportlab.clab.yml
```

**Port already in use**
```bash
sudo ss -tulpn | grep 50080
```

**Change to another port:**
```bash
ExecStart=/usr/local/bin/clab graph -t supportlab.clab.yml --srv :50081
```

**Then reload:**
```bash
sudo systemctl daemon-reload
sudo systemctl restart containerlab-graph
```
