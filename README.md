# agent-notif

Dead-simple push notifications from any machine to your iPhone. Built for Claude Code, SSH sessions, and cloud servers.

Uses [ntfy.sh](https://ntfy.sh) as transport (free, no server needed) with optional iOS Shortcuts-only mode.

## How it works

```
[Your machine] --HTTP POST--> [ntfy.sh] --Push--> [iPhone]
```

1. Run `agent-notif setup` on your machine — generates a QR code
2. Scan QR on iPhone to subscribe (ntfy.sh app) or import the iOS Shortcut
3. Send notifications: `notif "Build complete"` or `notif -s aws "Deploy finished"`

## Install

```bash
curl -sSL https://raw.githubusercontent.com/andy/agent-notif/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/andy/agent-notif.git
cd agent-notif
./install.sh
```

## Quick start

```bash
# First time — generates your private topic + QR code
agent-notif setup

# Scan the QR code with your iPhone camera (opens ntfy.sh app)
# Or: import the iOS Shortcut from the displayed URL

# Send a notification
notif "Hello from my machine"

# Label the source
notif -s laptop "Task done"
notif -s aws "EC2 instance ready"
notif -s claude "Long task finished"

# Priority levels
notif -p high "Server down!"
notif -p low "FYI: backup complete"

# Use in scripts / Claude Code
notif -s claude -p high "Your refactor is done — 47 files changed"
```

## Sources

Pre-configured source labels:

| Source | Flag | Emoji |
|--------|------|-------|
| Home PC | `-s home` | `🏠` |
| Laptop | `-s laptop` | `💻` |
| Claude Code | `-s claude` | `🤖` |
| AWS | `-s aws` | `☁️` |
| DigitalOcean | `-s do` | `🌊` |
| Lambda Labs | `-s lambda` | `🧠` |
| Custom | `-s "my-server"` | `📡` |

## iOS Shortcuts (no app needed)

If you don't want to install the ntfy.sh app:

1. Run `agent-notif shortcut` to generate a Shortcut import link
2. Open the link on your iPhone
3. The Shortcut polls ntfy.sh and shows native iOS notifications

See [docs/ios-shortcuts.md](docs/ios-shortcuts.md) for details.

## Claude Code integration

Add to your `CLAUDE.md`:

```markdown
When long tasks complete, notify me: `notif -s claude "description of what finished"`
```

Or use the hook system — see [docs/claude-code.md](docs/claude-code.md).

## SSH setup via QR

When you SSH into a remote machine:

```bash
# On remote machine
agent-notif setup --remote

# Displays QR in terminal — scan to subscribe
# Also copies your topic so notifications route to your phone
```

## Self-hosted ntfy

```bash
agent-notif setup --server https://your-ntfy-server.com
```

## Environment variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NOTIF_TOPIC` | ntfy.sh topic (auto-generated) | random |
| `NOTIF_SERVER` | ntfy.sh server URL | `https://ntfy.sh` |
| `NOTIF_SOURCE` | Default source label | hostname |
| `NOTIF_PRIORITY` | Default priority | `default` |

## License

MIT
