# Claude Code Integration

## Quick setup

1. Install agent-notif on your machine and run `agent-notif setup`
2. Subscribe on your iPhone (scan QR)
3. Add to your project's `CLAUDE.md`:

```markdown
After completing long-running tasks, send a notification:
  notif -s claude "brief description of what completed"
```

## Hook-based automation

You can use Claude Code's hook system to auto-notify on certain events.

### Notify on task completion

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "postToolUse": [
      {
        "matcher": "Bash",
        "command": "if echo \"$TOOL_INPUT\" | grep -q 'npm run build\\|make\\|cargo build\\|pytest\\|npm test'; then notif -s claude \"Build/test finished\"; fi"
      }
    ]
  }
}
```

### Notify on long commands

Create a wrapper that notifies if a command takes more than N seconds:

```bash
# Add to ~/.bashrc or ~/.zshrc
notif-if-slow() {
  local threshold="${NOTIF_THRESHOLD:-30}"
  local start=$SECONDS
  "$@"
  local exit_code=$?
  local elapsed=$((SECONDS - start))
  if (( elapsed > threshold )); then
    if (( exit_code == 0 )); then
      notif -s claude "Done (${elapsed}s): $1"
    else
      notif -s claude -p high "FAILED (${elapsed}s): $1"
    fi
  fi
  return $exit_code
}
```

## Usage patterns

```bash
# Simple completion notification
notif -s claude "Refactored auth module — 12 files changed"

# With priority for errors
notif -s claude -p high "Build failed: missing dependency foo-bar"

# Pipe output
npm test 2>&1 | tail -5 | notif -s claude

# In a script
if make build; then
  notif -s claude "Build succeeded"
else
  notif -s claude -p high "Build failed"
fi
```
