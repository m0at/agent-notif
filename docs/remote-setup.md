# Remote / SSH Setup

Send notifications from remote servers (AWS, DigitalOcean, Lambda Labs, etc.) to your iPhone.

## Quick install on remote

SSH into your server, then:

```bash
# One-liner install
curl -sSL https://raw.githubusercontent.com/andy/agent-notif/main/install.sh | bash

# Or just grab the script directly (it's a single file)
curl -sSL https://raw.githubusercontent.com/andy/agent-notif/main/agent-notif -o ~/.local/bin/agent-notif
chmod +x ~/.local/bin/agent-notif
```

## Copy your topic to the remote

You don't need to run `setup` on the remote — just copy your existing topic.

### Option A: Environment variable

```bash
# On remote, add to ~/.bashrc:
export NOTIF_TOPIC="your-topic-from-setup"
export NOTIF_SOURCE="aws"  # or do, lambda, etc.
```

### Option B: Copy config

```bash
# From your local machine:
scp ~/.config/agent-notif/config user@remote:~/.config/agent-notif/config

# Then on remote, update the source:
sed -i 's/NOTIF_SOURCE=.*/NOTIF_SOURCE="aws"/' ~/.config/agent-notif/config
```

### Option C: QR code (for new topic)

```bash
# On remote:
agent-notif setup --remote

# Displays QR in terminal — scan with iPhone
```

## Cloud-specific tips

### AWS EC2

```bash
# In user-data script:
curl -sSL https://raw.githubusercontent.com/andy/agent-notif/main/agent-notif -o /usr/local/bin/agent-notif
chmod +x /usr/local/bin/agent-notif

# Set topic via environment
export NOTIF_TOPIC="your-topic"
agent-notif send -s aws "EC2 instance $(curl -s http://169.254.169.254/latest/meta-data/instance-id) ready"
```

### DigitalOcean Droplet

```bash
# In cloud-init:
curl -sSL https://raw.githubusercontent.com/andy/agent-notif/main/agent-notif -o /usr/local/bin/agent-notif
chmod +x /usr/local/bin/agent-notif
NOTIF_TOPIC="your-topic" agent-notif send -s do "Droplet ready"
```

### Lambda Labs

```bash
# After SSH into GPU instance:
curl -sSL https://raw.githubusercontent.com/andy/agent-notif/main/agent-notif -o ~/.local/bin/agent-notif
chmod +x ~/.local/bin/agent-notif
export NOTIF_TOPIC="your-topic"

# Notify when training finishes
python train.py && notif -s lambda "Training complete" || notif -s lambda -p high "Training failed"
```

## Minimal mode (no install)

If you just want a one-off notification without installing anything:

```bash
curl -H "Title: ☁️ aws" -d "Deploy finished" https://ntfy.sh/YOUR_TOPIC
```

That's it. One curl command. Works on any machine with internet access.
