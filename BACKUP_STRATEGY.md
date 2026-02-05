# Backup Strategy

## Layers

### 1. Git Repository (Primary)
- All dotfiles version-controlled in this repo
- Push regularly: `cmpush` or `cd ~/dotfiles && git push`
- Full history of every configuration change

### 2. Chezmoi Recovery Snapshots
- `chezmoi-recover` creates timestamped tar backups before changes
- Stored in `~/.local/state/domus/snapshots/`
- Restore: `cmr list` then `cmr restore <n>`

### 3. 1Password (Secrets)
- All credentials stored in 1Password vaults
- Templates reference secrets via `onepasswordRead`
- Never stored in git, reconstructed at apply time

### 4. Homebrew Bundle (Packages)
- `manifest.yaml` lists all packages
- Reconstruct with `domus packages apply`
- Individual tools also have their own state (atuin history, zoxide db)

## Bare-Metal Recovery

On a fresh machine:

```bash
# 1. Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply 4444J99/domus-semper-palingenesis

# 2. Sign in to 1Password
op signin

# 3. Re-apply with secrets
chezmoi apply

# 4. Install full package manifest
domus packages apply

# 5. Verify
domus doctor
```

## What's NOT Backed Up

- Application data (databases, media files)
- Browser profiles and extensions
- IDE workspace state
- Docker images and volumes

These are considered ephemeral and reconstructible.
