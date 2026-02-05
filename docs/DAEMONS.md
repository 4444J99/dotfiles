# Daemon System

Three launchd agents maintain the system automatically.

## Agents

### com.chezmoi.self-heal
- **Schedule:** Every 4 hours
- **Purpose:** Detect and repair configuration drift
- **Actions:** Pull git updates, run `chezmoi apply`, create backups before changes
- **Plist:** `~/Library/LaunchAgents/com.chezmoi.self-heal.plist`

### com.domus.daemon
- **Schedule:** Every hour
- **Purpose:** Orchestrator for health checks and notifications
- **Actions:** Run health check, flush batched notifications, record telemetry
- **Plist:** `~/Library/LaunchAgents/com.domus.daemon.plist`

### com.domus.sort
- **Schedule:** Continuous (FSEvents watcher)
- **Purpose:** Automatically organize files in ~/Downloads
- **Actions:** Watch for new files, apply sorting rules from manifest.yaml
- **Plist:** `~/Library/LaunchAgents/com.domus.sort.plist`

## Management

```bash
# Check status
launchctl list | grep -E 'chezmoi|domus'

# View logs
tail -f ~/.local/state/domus/*.log

# Reload agents (after plist changes)
chezmoi apply  # triggers run_onchange_after_load-launchagent.sh

# Manual unload/load
launchctl unload ~/Library/LaunchAgents/com.domus.daemon.plist
launchctl load ~/Library/LaunchAgents/com.domus.daemon.plist
```

## Notification Tiers

Defined in `manifest.yaml` under `notifications`:

| Level | Examples | Behavior |
|-------|----------|----------|
| Silent | file sorted, health passed | Logged only |
| Quiet | rule matched (batched) | Batched, sent in groups |
| Normal | package update, drift detected | macOS notification |
| Urgent | critical failure, major drift | Immediate notification |

Quiet hours (default 22:00-08:00) suppress non-urgent notifications.
