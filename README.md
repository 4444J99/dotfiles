<div align="center">

# Domus Semper Palingenesis

**The Ever-Regenerating Home**

[Install](#install) · [How It Works](#how-it-works) · [Usage](#usage) · [Docs](#documentation)

</div>

---

## The Problem

Setting up a new development machine takes hours. Secrets accidentally end up in Git history. Configurations silently drift between devices until something breaks. When it does break, there's no easy way back.

## The Approach

This system uses [chezmoi](https://chezmoi.io) with three interlocking strategies:

**1. Secrets never touch Git.** All credentials—GitHub tokens, AWS keys, SSH identities—live in 1Password. Templates pull them at apply time, so the repository stays clean.

**2. One source, many targets.** Templated configs generate the right paths, tools, and settings for each OS. macOS ARM64, Intel, and Linux all derive from the same files.

**3. The system heals itself.** A launchd daemon watches for drift, pulls updates, creates backups, and repairs divergence automatically. If something breaks, recovery is one command away.

## The Outcome

A single command provisions a new machine with every tool configured, every secret in place, and a unified terminal aesthetic. The environment stays consistent across devices without manual intervention. When problems occur, the system either fixes them silently or provides clear recovery paths.

---

## Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply 4444J99/domus-semper-palingenesis
```

This installs chezmoi, clones the repo, prompts for machine config, fetches secrets from 1Password, and applies everything.

## How It Works

### Secret Management

Credentials are referenced in templates, resolved at apply time:

```ini
[github]
token = {{ onepasswordRead "op://Personal/GitHub/token" }}
```

The repository contains zero secrets. 1Password CLI handles authentication.

### Self-Healing Daemon

Runs every 4 hours via launchd:

- Pulls latest changes from Git
- Detects configuration drift  
- Creates timestamped backups before any repair
- Sends macOS notifications when intervention is needed

```bash
cmh              # Check system health
cmr list         # View available backups
cmr restore <n>  # Restore from backup
```

### Tokyo Night Terminal

All terminal tools share a unified color palette (`#1a1b26` background, `#7aa2f7` blue, `#bb9af7` purple):

- **Kitty** — JetBrains Mono Nerd Font, macOS keybindings, splits
- **tmux** — TPM plugins, session persistence across reboots
- **fzf** — Themed fuzzy finder with Nerd Font glyphs
- **lazygit** — Git TUI with delta pager integration
- **bat/delta** — Syntax-highlighted file viewing and diffs
- **starship** — Prompt with git status and language indicators

## Usage

```bash
cma     # Apply changes
cmd     # Preview diff
cme     # Edit file
cmu     # Update from remote
cmh     # Health check
cmr     # Recovery tool
lg      # Launch lazygit
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoiscripts/        # Package install, daemon setup
├── dot_config/
│   ├── kitty/              # Terminal config
│   ├── tmux/               # Multiplexer + TPM
│   ├── lazygit/            # Git TUI
│   ├── bat/                # Cat replacement
│   ├── git/                # Git + delta pager
│   └── starship.toml       # Prompt
├── dot_zshrc.tmpl          # Shell configuration
├── private_dot_ssh/        # SSH via 1Password agent
└── private_Library/        # macOS LaunchAgent
```

## Documentation

| Guide | Purpose |
|-------|---------|
| [1PASSWORD_SETUP.md](1PASSWORD_SETUP.md) | Configure secret management |
| [EXTERNAL_DRIVE.md](EXTERNAL_DRIVE.md) | External drive integration |
| [ORGANIZATION_STRATEGY.md](ORGANIZATION_STRATEGY.md) | File organization system |

---

<div align="center">

**50+ managed files · 15 templates · 0 secrets in Git**

MIT · [chezmoi](https://chezmoi.io) · [Tokyo Night](https://github.com/folke/tokyonight.nvim)

</div>
