# Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    User Interface Layer                       │
│                                                               │
│  domus CLI ─── domus status/apply/sort/packages/perf/doctor  │
│  chezmoi  ─── cma/cmd/cme/cmu/cms                           │
│  just     ─── j lint/test/health/apply/fmt                   │
└──────────┬──────────────────────────────────────┬────────────┘
           │                                      │
┌──────────▼──────────┐            ┌──────────────▼────────────┐
│   Dotfiles Engine   │            │     Package Manager       │
│                     │            │                           │
│  chezmoi            │            │  domus-packages           │
│  ├─ templates (.tmpl)│           │  ├─ manifest.yaml         │
│  ├─ 1Password refs  │            │  ├─ brew formulae/casks   │
│  └─ OS conditionals │            │  ├─ pipx packages         │
│                     │            │  └─ npm globals            │
└──────────┬──────────┘            └──────────────┬────────────┘
           │                                      │
┌──────────▼──────────────────────────────────────▼────────────┐
│                     Daemon Layer (launchd)                    │
│                                                               │
│  com.chezmoi.self-heal  ─── 4hr drift check + auto-repair    │
│  com.domus.daemon       ─── 1hr orchestrator (health+notify) │
│  com.domus.sort         ─── FSEvents file watcher + sorter   │
└──────────┬──────────────────────────────────────┬────────────┘
           │                                      │
┌──────────▼──────────┐            ┌──────────────▼────────────┐
│   Health & Recovery  │            │     Notification          │
│                     │            │                           │
│  chezmoi-health     │            │  domus-notify             │
│  chezmoi-recover    │            │  ├─ tiered levels         │
│                     │            │  ├─ quiet hours           │
│                     │            │  └─ batch support         │
└─────────────────────┘            └───────────────────────────┘
```

## ZSH Module Loading Order

```
dot_zshrc (entry point)
  └─ sources ~/.config/zsh/*.zsh in order:

  00-init.zsh        ─── Startup timing, root guard
  10-path.zsh        ─── PATH (Homebrew, Ruby, Go, Python, toolchains)
  15-env.zsh         ─── XDG dirs, EDITOR, CARGO_HOME, RUSTUP_HOME
  20-tools.zsh       ─── Tool init (starship, zoxide, fzf, atuin, direnv, mise)
  30-aliases.zsh     ─── All aliases (git, chezmoi, eza, bat, domus, just)
  40-functions.zsh   ─── Custom functions (maintain, cache-sizes, ktheme, cht)
  50-completions.zsh ─── compinit, Docker completions, styling
  85-plugins.zsh     ─── zsh-autosuggestions, zsh-syntax-highlighting
  90-telemetry.zsh   ─── Record startup time, deduplicate PATH
  99-local.zsh.tmpl  ─── Machine-specific overrides (optional)
```

## Template Flow

```
chezmoi source (.tmpl files)
        │
        ▼
  ┌─────────────┐
  │ Go template  │◄──── chezmoi data (.chezmoi.toml)
  │   engine     │◄──── 1Password CLI (onepasswordRead)
  │              │◄──── OS detection (.chezmoi.os, .chezmoi.arch)
  └──────┬──────┘
         │
         ▼
  Target files (~/.config/*, ~/.ssh/*, etc.)
```

## File Organization (domus-sort)

```
~/Downloads/
  ├─ *.dmg, *.pkg ────────► ~/Downloads/_Installers/
  ├─ *.zip, *.tar.* ──────► ~/Downloads/_Archives/{year}/
  ├─ *.pdf ────────────────► ~/Documents/PDFs/{year}/
  ├─ *.png, *.jpg ─────────► ~/Pictures/Downloads/{year}/{month}/
  ├─ Screenshots/ ─────────► ~/Pictures/Screenshots/{year}/{month}/
  └─ 30+ day old files ───► ~/Downloads/_Archive/{year}/
```

## Secret Management

All secrets flow through 1Password, never stored in git:

```
1Password Vault
  └─ op://Personal/...
        │
        ▼
  chezmoi template: {{ onepasswordRead "op://Personal/..." }}
        │
        ▼
  Rendered file (target only, never committed)
```

Secrets used: GitHub tokens, AWS credentials, SSH agent socket, API keys.
