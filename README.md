# agent-notif

Push notifications from any machine to your iPhone. Zero external APIs.

Sends email via SSH to your [amail](https://github.com/m0at/amail) server → iPhone Mail notifies you via VIP or Shortcuts automation.

```
[any machine] --SSH--> [amail droplet] --SMTP localhost:25--> [email] --iOS Mail--> [notification]
```

## Install

```bash
git clone https://github.com/m0at/agent-notif.git
cd agent-notif
./install.sh
```

## Quick start

```bash
# Auto-detects amail settings.json
agent-notif setup

# On iPhone: mark the sender as VIP in Mail (one time)
# That's it — VIP emails get banner notifications

# Send a notification
notif "Hello from my machine"
notif -s claude "Refactor done: 47 files changed"
notif -s aws "Deploy finished"
notif -s lambda -p high "Training complete"
```

## How it works

1. `agent-notif setup` reads `~/amail/settings.json` for SSH + SMTP config
2. `notif "message"` SSHs into your mail server, sends email via `localhost:25`
3. iPhone Mail shows notification (VIP sender = banner + sound, even in DND)

No APIs. No third-party services. Just SSH + SMTP you already own.

## Sources

| Source | Flag | Emoji |
|--------|------|-------|
| Home PC | `-s home` | `🏠` |
| Laptop | `-s laptop` | `💻` |
| Claude Code | `-s claude` | `🤖` |
| AWS | `-s aws` | `☁️` |
| DigitalOcean | `-s do` | `🌊` |
| Lambda Labs | `-s lambda` | `🧠` |
| Custom | `-s "my-server"` | `📡` |

## iPhone setup

### Option 1: VIP (easiest, zero config)

1. Open Mail on iPhone
2. Open any email from your notification sender address
3. Tap the sender name → **Add to VIP**

VIP emails get their own notification sound, show on Lock Screen, and bypass Focus/DND filters.

### Option 2: Shortcuts automation (more control)

1. Shortcuts → Automation → **Email**
2. Trigger: Subject contains `[notif]`
3. Action: **Show Notification** (use email subject as body)
4. Disable "Ask Before Running"

This lets you customize the notification appearance, play custom sounds, log to Notes, etc.

## Claude Code integration

Add to your project's `CLAUDE.md`:

```markdown
After completing long-running tasks, notify me:
  notif -s claude "brief description of what completed"
```

See [docs/claude-code.md](docs/claude-code.md) for hook-based automation.

## Remote machines

Machines that have your SSH key can send directly:

```bash
# Copy agent-notif + set config
scp ~/.config/agent-notif/config user@remote:~/.config/agent-notif/config

# Or just set env vars
export NOTIF_SSH_HOST="138.68.x.x"
export NOTIF_SSH_KEY="~/.ssh/id_ed25519"
export NOTIF_SSH_USER="root"
export NOTIF_FROM="admin@yourdomain.com"
export NOTIF_TO="admin@yourdomain.com"
```

Minimal one-liner (no install needed):

```bash
ssh -i ~/.ssh/id_ed25519 root@YOUR_SERVER \
  "python3 -c \"import smtplib; from email.mime.text import MIMEText; m=MIMEText('done'); m['From']='a@x.co'; m['To']='a@x.co'; m['Subject']='[notif] Build done'; smtplib.SMTP('localhost',25).send_message(m)\""
```

See [docs/remote-setup.md](docs/remote-setup.md) for cloud-specific guides.

## Fallback: ntfy.sh

If you don't have an amail server, agent-notif falls back to [ntfy.sh](https://ntfy.sh) (free, but requires their iOS app):

```bash
# Without amail, setup auto-detects and uses ntfy
agent-notif setup
```

## License

MIT
