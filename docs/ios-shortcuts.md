# iOS Setup

Three ways to get notifications, from simplest to most customizable. All use built-in iOS apps — nothing to install.

## Option 1: Mail VIP (recommended)

The simplest. One-time setup, instant push notifications.

1. Open **Mail** on iPhone
2. Open any email from your notification sender (e.g. `admin@a-ndy.co`)
3. Tap the sender name → **Add to VIP**

Done. VIP emails:
- Show banner notifications on Lock Screen
- Have their own notification sound (customizable in Settings → Notifications → Mail → VIP)
- Can bypass Focus / Do Not Disturb (Settings → Focus → allow VIP mail)
- Show in the VIP mailbox for quick review

### Why this works

Every `notif` command sends an email with subject like:
```
[notif] 🤖 claude: Refactor complete
```

iOS Mail delivers push notifications for VIP senders instantly. No polling, no third-party app, no API.

## Option 2: Shortcuts Email Automation (more control)

Triggers a Shortcut when a notification email arrives. Lets you customize what happens.

1. Open **Shortcuts** → **Automation** tab
2. Tap **+** → **Email**
3. Set trigger:
   - **Subject Contains**: `[notif]`
   - (or **Sender Is**: your notification address)
4. Add actions:
   - **Show Notification**: use the email subject as the notification body
5. Turn off **Ask Before Running**

### Advanced: parse and route

You can build more complex Shortcuts that:
- Extract the source emoji from the subject to set notification category
- Log notifications to a Notes document
- Forward high-priority ones to a different alert sound
- Trigger HomeKit scenes (e.g. flash a light when deploy finishes)

Example Shortcut flow:
```
Email arrives with subject "[notif] ☁️ aws: Deploy finished"
→ Get text from subject
→ If subject contains "high" → Play critical alert sound
→ Show Notification with parsed message
→ Add row to "Notification Log" note
```

## Option 3: Mail Rules + Shortcuts

Use Mail rules on your Mac (or server-side Sieve rules) to:
1. Move notification emails to a dedicated folder
2. Mark them with a specific flag
3. Trigger a Shortcut based on the flag

This keeps your inbox clean while still getting push notifications.

## Subject format

All notifications use this subject format for easy filtering:

```
[notif] EMOJI SOURCE: MESSAGE
```

Examples:
```
[notif] 🤖 claude: Build complete — 12 files changed
[notif] ☁️ aws: EC2 instance i-abc123 ready
[notif] 🧠 lambda: Training epoch 50/100 done
[notif] 🏠 home: Backup finished
```

The `[notif]` prefix makes it trivial to filter in any email client or Shortcut automation.
