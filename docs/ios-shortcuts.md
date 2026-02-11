# iOS Shortcuts Setup

Three ways to get notifications on your iPhone, from easiest to most DIY.

## Option 1: ntfy.sh App (recommended)

The simplest path. Install once, scan QR, done.

1. Install **ntfy** from the App Store
2. Run `agent-notif qr` on your machine
3. Scan the QR code or open the URL in Safari
4. The ntfy app subscribes and delivers native push notifications

That's it. The app handles everything — background delivery, notification grouping, priority levels.

## Option 2: Polling Shortcut (no app)

If you don't want to install any app, you can use iOS Shortcuts to poll ntfy.sh periodically.

### Create the Shortcut

1. Open **Shortcuts** app
2. Tap **+** to create new Shortcut
3. Add these actions:

**Step 1:** Get Contents of URL
```
URL: https://ntfy.sh/YOUR_TOPIC/json?poll=1&since=5m
Method: GET
```

**Step 2:** Repeat with Each (from Step 1)
- Inside the loop:

**Step 3:** Get Dictionary Value
```
Key: message
Dictionary: Repeat Item
```

**Step 4:** Show Notification
```
Body: (Dictionary Value from Step 3)
```

### Set up Automation

1. Go to **Automation** tab in Shortcuts
2. Tap **+** → **Time of Day**
3. Set to repeat every 5 minutes (or your preference)
4. Action: Run your notification Shortcut
5. Turn off "Ask Before Running"

### Limitations

- Minimum polling interval is ~5 minutes
- Won't work if phone is in low power mode
- Notifications are slightly delayed vs push

## Option 3: Pushover (alternative transport)

If you prefer Pushover over ntfy.sh:

1. Install Pushover app ($4.99 one-time)
2. Get your User Key from the app
3. Register an API token at pushover.net
4. Set environment variables:

```bash
export NOTIF_TRANSPORT=pushover
export PUSHOVER_USER=your-user-key
export PUSHOVER_TOKEN=your-app-token
```

(Pushover support is planned for a future release)

## Tips

- **Battery**: The ntfy.sh app uses Apple's push notification service, so it uses minimal battery. The polling Shortcut approach uses more.
- **Privacy**: Your topic URL is a secret. Anyone who knows it can send you notifications. Keep it private.
- **Multiple devices**: Just subscribe on each device. ntfy.sh delivers to all subscribers.
- **Filtering**: In the ntfy app, you can mute specific topics or set Do Not Disturb schedules.
