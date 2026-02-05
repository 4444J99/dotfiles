# Domus CLI Reference

## Commands

| Command | Description |
|---------|-------------|
| `domus` | Status summary (default) |
| `domus status [--json]` | Full status report |
| `domus apply [--dry-run]` | Sync dotfiles + packages |
| `domus apply --dotfiles` | Sync dotfiles only |
| `domus apply --packages` | Sync packages only |
| `domus sort [--watch]` | Run file sorter |
| `domus packages diff` | Show package drift |
| `domus packages apply` | Install missing packages |
| `domus perf shell` | Shell startup time trend |
| `domus perf daemon` | Daemon run times |
| `domus health [--json]` | Chezmoi health check |
| `domus doctor` | Comprehensive diagnostics |

## Shell Aliases

```bash
dm    → domus
dms   → domus status
dma   → domus apply
dmp   → domus packages
dmpd  → domus packages diff
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Issues detected (drift, warnings) |
| 2 | Error |

## Supporting Tools

| Tool | Purpose |
|------|---------|
| `domus-packages` | Package tracking and drift detection |
| `domus-sort` | FSEvents file watcher and sorter |
| `domus-daemon` | Hourly orchestrator daemon |
| `domus-notify` | Tiered notification dispatcher |
| `chezmoi-health` | Drift detection and health checks |
| `chezmoi-recover` | Backup and recovery system |
| `theme-switch` | pywal theme management |
