# Development Guide

## Adding a ZSH Module

1. Create `dot_config/zsh/XX-name.zsh` where XX determines load order
2. Load order: init(00) → path(10) → env(15) → tools(20) → aliases(30) → functions(40) → completions(50) → plugins(85) → telemetry(90) → local(99)
3. Use `command -v tool &>/dev/null` guards for optional dependencies
4. The module is automatically sourced by `dot_zshrc`

## Adding a Package to Manifest

1. Edit `dot_config/domus/manifest.yaml`
2. Add to the appropriate section: `homebrew.formulae`, `homebrew.casks`, `pipx`, or `npm_global`
3. Run `domus packages diff` to verify
4. Run `domus packages apply` to install

## Adding a LaunchAgent

1. Create plist template in `private_Library/LaunchAgents/`
2. Name: `com.domus.<name>.plist.tmpl` or `com.chezmoi.<name>.plist.tmpl`
3. Add load/unload logic to `.chezmoiscripts/run_onchange_after_load-launchagent.sh.tmpl`
4. Create the executable in `dot_local/bin/`

## Creating a Template

1. Add `.tmpl` extension to the file
2. Use `{{ .chezmoi.os }}` for OS conditionals
3. Use `{{ onepasswordRead "op://..." }}` for secrets
4. Test with `chezmoi execute-template < file.tmpl`
5. Validate: `just template-check`

## Testing Changes

```bash
# Lint all scripts and configs
just lint

# Run template validation
just template-check

# Run BATS tests
just test

# Preview changes without applying
chezmoi diff
# or
just diff

# Dry run apply
just dry-run
```

## Debugging Daemons

```bash
# Check if agents are loaded
launchctl list | grep -E 'chezmoi|domus'

# View daemon logs
tail -f ~/.local/state/domus/*.log

# Run daemon manually for debugging
~/.local/bin/domus-daemon

# Check health
domus doctor
```

## Script Conventions

- Shebang: `#!/usr/bin/env bash`
- Always: `set -euo pipefail`
- Use `command -v` instead of `which`
- Quote all variables
- Use `[[` for conditionals
