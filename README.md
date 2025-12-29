# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/), featuring 1Password secret management, multi-OS support, and XDG Base Directory compliance.

## 🚀 Quick Start

### New Machine Setup

Single command setup:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply 4444JPP
```

This will:
- Install chezmoi
- Clone this repository
- Prompt for email and machine type (work/personal)
- Fetch secrets from 1Password
- Apply all configurations

### Existing Machine

```bash
# Apply changes
cma          # alias for: chezmoi apply

# Preview changes
cmd          # alias for: chezmoi diff

# Edit a file
cme ~/.zshrc # alias for: chezmoi edit

# Update from GitHub
cmu          # alias for: chezmoi update
```

## 📋 Features

### ✅ Implemented

- **Secret Management**: GitHub tokens, AWS credentials via 1Password (never in Git)
- **Multi-OS Support**: macOS (ARM64/Intel) and Linux configurations
- **XDG Compliance**: 28 apps organized in `~/.local/share/`
- **External Drive Integration**: Auto-detection and symlink creation
- **Shell Aliases**: Quick access to common chezmoi operations
- **Auto-commit/Auto-push**: Automatic Git operations enabled

### 🎯 Managed Configurations

- **Shell**: `.zshrc` with OS-specific paths and Homebrew setup
- **Git**: XDG-compliant config at `~/.config/git/config`
- **SSH**: 1Password SSH agent integration with connection reuse
- **AWS**: Template-based credentials (activate with 1Password items)
- **Environment**: Centralized variables in `~/.config/environment`

## 📚 Documentation

### Core Guides

| Document | Purpose |
|----------|---------|
| [1PASSWORD_SETUP.md](1PASSWORD_SETUP.md) | Secret management configuration |
| [EXTERNAL_DRIVE.md](EXTERNAL_DRIVE.md) | External drive integration guide |
| [ORGANIZATION_STRATEGY.md](ORGANIZATION_STRATEGY.md) | File organization architecture (3-layer system) |
| [ORGANIZATION_QUICKSTART.md](ORGANIZATION_QUICKSTART.md) | 5-minute quick start guide |
| [DOTFILES_CLEANUP.md](DOTFILES_CLEANUP.md) | Dotfile migration strategy (59→25 goal) |
| [PLUGINS.md](PLUGINS.md) | Claude Code plugins reference |

### Quick Reference

**Chezmoi Aliases:**
- `cm` - chezmoi
- `cma` - chezmoi apply
- `cmd` - chezmoi diff
- `cme` - chezmoi edit
- `cms` - chezmoi status
- `cmcd` - cd to dotfiles repo
- `cmpush` - push changes to GitHub
- `cmlog` - view recent commits

**File Organization:**
- `file-org check-external` - Check external drive status
- `file-org inventory` - Generate file inventory
- `file-org clean-root` - List files in home root

## 🗂️ Structure

```
~/.local/share/chezmoi/          # Source state (this repo)
├── dot_config/
│   ├── git/
│   │   ├── config.tmpl          # Git configuration
│   │   └── ignore               # Global gitignore
│   ├── environment.tmpl         # Environment variables
│   └── kitty/
│       └── kitty.conf.tmpl      # Terminal configuration
├── dot_zshrc.tmpl               # Shell configuration
├── private_dot_aws/
│   └── credentials.tmpl         # AWS credentials (1Password)
├── private_dot_ssh/
│   └── private_config.tmpl      # SSH configuration
└── run_once_before_*.sh.tmpl    # Setup scripts
```

## 🔐 Security

### Secrets Management

All secrets managed via 1Password:
- GitHub token: `master-org-token-110525` <!-- allow-secret -->
- AWS credentials: Create "AWS Personal" item (see [1PASSWORD_SETUP.md](1PASSWORD_SETUP.md))
- SSH keys: Managed by 1Password SSH agent

**Zero secrets in Git repository.**

### Secret Template Example

```ini
# In ~/.config/git/config.tmpl
[github]
  token = {{ onepasswordRead "op://Personal/master-org-token-110525/token" }} # allow-secret
```

## 🖥️ Multi-OS Support

### macOS-specific
- Homebrew paths (ARM64 vs Intel)
- iTerm2 shell integration
- 1Password SSH agent path
- External drive auto-detection

### Linux-specific
- Alternative Homebrew path
- Different 1Password SSH agent location
- Conditional package installs

### Template Example

```bash
{{- if eq .chezmoi.os "darwin" }}
export PATH="/opt/homebrew/bin:$PATH"  # macOS ARM64
{{- else if eq .chezmoi.os "linux" }}
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"  # Linux
{{- end }}
```

## 📦 XDG Base Directory Compliance

28 applications migrated to XDG locations with backward-compatible symlinks:

**AI/ML Tools** (~5.8GB):
- claude, gemini, ollama, antigravity
- codex, cloudbase-mcp, mcp-auth
- aitk, jules, genkit, my-father-mother

**IDE/Dev Tools** (~13GB):
- vscode, vscode-insiders, cursor
- gitkraken, dropbox, vs-kubernetes
- copilot, codestream, quokka, wallaby

All apps still work via symlinks at original locations.

## 🔄 External Drive

Automatic symlink creation when `/Volumes/4444-iivii` is connected:

```bash
~/External              → /Volumes/4444-iivii
~/Projects/ivi374       → External/ivi374forivi3ivi3/workspace
~/.local/share/toolchains → External/ivi374forivi3ivi3/toolchains
```

See [EXTERNAL_DRIVE.md](EXTERNAL_DRIVE.md) for details.

## 🛠️ Customization

### Add New Machine

1. Run chezmoi init
2. Answer prompts (email, work/personal)
3. Create 1Password items for secrets
4. Run `chezmoi apply`

### Add New Secret

1. Create 1Password item
2. Edit template:
   ```bash
   cme ~/.aws/credentials
   ```
3. Add onepasswordRead reference:
   ```ini
   aws_access_key_id = {{ onepasswordRead "op://Personal/AWS Personal/access_key_id" }}
   ```
4. Apply: `cma`

### Add New Configuration

```bash
# Add existing file
chezmoi add ~/.someconfig

# Edit template
cme ~/.someconfig

# Add template variables if needed
# Apply
cma
```

## 📊 Statistics

- **Managed Files**: 31+
- **GitHub Commits**: 15+
- **XDG Migrations**: 28 apps (~17GB)
- **Dotfiles Reduced**: 59 → 52 (goal: ~25)
- **Secrets in Git**: 0

## 🎯 Future Enhancements

- [ ] Create bootstrap script for automated first-run
- [ ] Add more AWS/cloud provider templates
- [ ] Expand OS-specific configurations
- [ ] Add browser extension manifest
- [ ] Periodic health check script

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Fork for your own use
- Open issues for suggestions
- Submit PRs for improvements

## 📝 License

MIT

## 🔗 Resources

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [XDG Base Directory Spec](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [1Password CLI](https://developer.1password.com/docs/cli/)
- [Dotfiles Best Practices](https://dotfiles.github.io/)

---

**Last Updated**: 2025-12-29
**Repository**: [github.com/4444JPP/dotfiles](https://github.com/4444JPP/dotfiles)
