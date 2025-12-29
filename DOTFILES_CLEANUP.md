# Dotfiles Cleanup Guide
## Can All Dotfiles Be Moved Out of Home?

**Your Question:** Can ALL dotfolders be moved out of `~/`?

**Short Answer:** No, but many can! You have **59 dotfiles/folders** - here's what can and cannot be moved.

---

## Current Dotfiles Audit (59 Total)

### ✅ Already XDG-Compliant (Keep in Home)

These are **correct** and should stay:

```
~/.config/         ← XDG Base Directory (this is the right place!)
~/.local/          ← XDG Base Directory (correct!)
~/.cache/          ← XDG Base Directory (correct!)
```

**Action:** ✅ Keep these, they're already following modern standards

---

### ❌ CANNOT Be Moved (Hardcoded Paths)

These applications **do not support XDG** and must stay in `~/`:

**Shell Configuration (Must Stay):**
```
~/.zshrc           ← Zsh reads from home
~/.zprofile        ← Zsh reads from home
~/.bash_history    ← Bash hardcoded
~/.zsh_history     ← Zsh hardcoded
~/.zcompdump       ← Zsh completion cache
~/.zsh_sessions/   ← Zsh session data
```

**SSH (Must Stay):**
```
~/.ssh/            ← SSH hardcoded to ~/.ssh/
                     (Cannot be changed without recompiling OpenSSH)
```

**Development Tools (Must Stay):**
```
~/.gitconfig       ← Git reads from home (but can use XDG_CONFIG_HOME/git/config)
~/.viminfo         ← Vim history (unless using Neovim)
~/.npm/            ← npm hardcoded
~/.docker/         ← Docker hardcoded
~/.kube/           ← kubectl hardcoded
~/.terraform.d/    ← Terraform hardcoded
~/.bundle/         ← Ruby Bundler hardcoded
```

**Other Hardcoded:**
```
~/.aws/            ← AWS CLI hardcoded to ~/.aws/
~/.boto            ← Google Cloud Storage tool
~/.gsutil/         ← Google Storage Utility
~/.node_repl_history  ← Node.js REPL
```

**Action:** ❌ Cannot move these - applications won't find them

---

### ⚠️ CAN Be Moved (With Work)

These **could** move to XDG locations, but require configuration:

**Git (Special Case):**
```
~/.gitconfig       → ~/.config/git/config
~/.gitignore_global → ~/.config/git/ignore
```

**How to move:**
```bash
# Move git config to XDG location
mkdir -p ~/.config/git
mv ~/.gitconfig ~/.config/git/config
mv ~/.gitignore_global ~/.config/git/ignore

# Git will automatically find it in ~/.config/git/
```

**Other XDG-aware apps:**
```
Some apps check both locations:
1. ~/.apprc (legacy)
2. $XDG_CONFIG_HOME/app/config (modern)

These can gradually migrate as apps get updated
```

---

### 🗑️ SHOULD Be Deleted (Cleanup)

These can be safely removed:

**Backups:**
```bash
~/.zshrc.backup    ← Old backup
~/.claude.json.backup  ← Old backup
~/.gemini.bak      ← Old backup
~/.vscode_extensions_backup_20251123_113018  ← Old backup
```

**System Junk:**
```bash
~/.DS_Store        ← macOS metadata (regenerates)
```

**Commands to clean up:**
```bash
# Remove backup files
rm ~/.zshrc.backup ~/.claude.json.backup ~/.gemini.bak
rm -rf ~/.vscode_extensions_backup_*

# Remove macOS junk
rm ~/.DS_Store
```

---

### 📦 SHOULD Move to ~/.local/share/

These are **application data** that belong in `~/.local/share/`:

**AI/ML Tools:**
```
~/.aitk/           → ~/.local/share/aitk/
~/.antigravity/    → ~/.local/share/antigravity/
~/.claude/         → ~/.local/share/claude/
~/.claude-server-commander/ → ~/.local/share/claude-server-commander/
~/.gemini/         → ~/.local/share/gemini/
~/.genkit/         → ~/.local/share/genkit/
~/.ollama/         → ~/.local/share/ollama/
~/.jules/          → ~/.local/share/jules/
```

**IDE/Editor Data:**
```
~/.vscode/         → ~/.local/share/vscode/  (or keep, it's large)
~/.vscode-insiders/ → ~/.local/share/vscode-insiders/
~/.cursor/         → ~/.local/share/cursor/
~/.codestream/     → ~/.local/share/codestream/
~/.copilot/        → ~/.local/share/copilot/
~/.wallaby/        → ~/.local/share/wallaby/
~/.quokka/         → ~/.local/share/quokka/
```

**Other Apps:**
```
~/.cloudbase-mcp/  → ~/.local/share/cloudbase-mcp/
~/.codex/          → ~/.local/share/codex/
~/.dropbox/        → ~/.local/share/dropbox/
~/.dropbox_bi/     → ~/.local/share/dropbox_bi/
~/.gitkraken/      → ~/.local/share/gitkraken/
~/.gk/             → ~/.local/share/gk/
~/.mcp-auth/       → ~/.local/share/mcp-auth/
~/.my-father-mother/ → ~/.local/share/my-father-mother/
~/.pdf-filler-profiles/ → ~/.local/share/pdf-filler-profiles/
~/.redhat/         → ~/.local/share/redhat/
~/.swiftpm/        → ~/.local/share/swiftpm/
~/.thumbnails/     → ~/.local/share/thumbnails/
~/.vs-kubernetes/  → ~/.local/share/vs-kubernetes/
```

**How to move (example):**
```bash
# Move an app to XDG location
mv ~/.claude ~/.local/share/claude

# Create symlink for backward compatibility
ln -s ~/.local/share/claude ~/.claude
```

**Caution:** Some apps may break if moved. Test first or use symlinks.

---

### 🔄 SHOULD Move to ~/.config/

These are **configurations** that belong in `~/.config/`:

**Already moved by chezmoi:**
```
~/.gitconfig       → ~/.config/git/config (via chezmoi)
~/.gitignore_global → ~/.config/git/ignore (via chezmoi)
```

**App configs that could move:**
```
~/.claude.json     → ~/.config/claude/config.json
```

---

## Summary by Category

| Category | Count | Action |
|----------|-------|--------|
| **XDG Compliant** (keep) | 3 | ✅ Already correct |
| **Must Stay** (hardcoded) | 20 | ❌ Cannot move |
| **Can Move** (with config) | 2 | ⚠️ Optional migration |
| **Should Delete** (cleanup) | 4 | 🗑️ Safe to remove |
| **Should Move to ~/.local/share/** | 30+ | 📦 Recommended migration |

---

## Recommended Cleanup Strategy

### Phase 1: Safe Cleanup (5 minutes)

```bash
# Delete backup files
rm ~/.zshrc.backup
rm ~/.claude.json.backup
rm ~/.gemini.bak
rm -rf ~/.vscode_extensions_backup_*
rm ~/.DS_Store

# Result: 4-5 fewer dotfiles ✅
```

### Phase 2: Move Git to XDG (2 minutes)

```bash
# Git config
mkdir -p ~/.config/git
mv ~/.gitconfig ~/.config/git/config
mv ~/.gitignore_global ~/.config/git/ignore

# Result: 2 fewer dotfiles in ~/ ✅
# Git automatically finds config in ~/.config/git/
```

### Phase 3: Gradual App Migration (Over time)

**Low Risk - Use Symlinks:**
```bash
# Example: Move .claude to XDG with backward compatibility
mv ~/.claude ~/.local/share/claude
ln -s ~/.local/share/claude ~/.claude

# App still finds it, but organized in XDG location
```

**Higher Risk - Test First:**
```bash
# Some apps may have hardcoded paths
# Test on one app first before moving all
```

### Phase 4: Accept What Must Stay (Reality Check)

These **cannot** be moved and that's **okay**:
```
~/.ssh/            ← Security-critical, hardcoded
~/.zshrc           ← Shell needs it
~/.docker/         ← Docker hardcoded
~/.npm/            ← npm hardcoded
~/.kube/           ← kubectl hardcoded
```

**Modern perspective:**
- ~15-20 essential dotfiles in ~/ is **normal** and **acceptable**
- The goal isn't zero dotfiles, it's **organized** dotfiles

---

## Practical Example: Your Home After Cleanup

### Before (59 dotfiles):
```
~/ (cluttered)
├── .aitk/
├── .antigravity/
├── .aws/
├── .bash_history
├── .boto
├── .bundle/
├── .cache/
├── .claude/
├── .claude.json
├── .claude.json.backup  ← DELETE
├── .cloudbase-mcp/
├── .codestream/
├── ... (50 more)
```

### After Cleanup (20-25 essential dotfiles):
```
~/ (clean & organized)
├── .config/           ← Configurations (XDG)
├── .local/            ← App data (XDG)
│   └── share/
│       ├── claude/    ← Moved from ~/
│       ├── gemini/    ← Moved from ~/
│       └── ...
├── .cache/            ← Temp data (XDG)
│
├── .ssh/              ← Must stay (hardcoded)
├── .zshrc             ← Must stay (shell)
├── .docker/           ← Must stay (hardcoded)
├── .npm/              ← Must stay (hardcoded)
├── .kube/             ← Must stay (hardcoded)
├── .aws/              ← Must stay (hardcoded)
└── ... (10-15 essential dotfiles that cannot move)
```

**Result:** Clean, organized, XDG-compliant while respecting tool limitations

---

## Tools to Help

### 1. Check What Apps Support XDG

```bash
# See if an app checks XDG_CONFIG_HOME
strace -e openat appname 2>&1 | grep XDG

# On macOS use:
dtruss -f appname 2>&1 | grep XDG
```

### 2. Safe Migration Script

```bash
#!/bin/bash
# safe-move.sh - Move with backward-compatible symlink

APP_NAME="$1"
FROM="$HOME/.$APP_NAME"
TO="$HOME/.local/share/$APP_NAME"

if [ -d "$FROM" ]; then
  mv "$FROM" "$TO"
  ln -s "$TO" "$FROM"
  echo "Moved $FROM → $TO (with symlink)"
else
  echo "Not found: $FROM"
fi
```

**Usage:**
```bash
chmod +x safe-move.sh
./safe-move.sh claude
./safe-move.sh gemini
# etc.
```

### 3. Monitor App Behavior

```bash
# Watch what an app tries to access
sudo fs_usage -w -f filesystem | grep ~/.appname
```

---

## XDG Environment Variables

Set these in your shell config to encourage XDG compliance:

```bash
# Already in your environment.tmpl! ✅
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
```

Apps that support XDG will automatically use these locations.

---

## Reality Check: What's Actually Achievable

### Realistic Goal:
- Start: **59 dotfiles**
- After cleanup: **20-25 essential dotfiles**
- Reduction: **~40% cleaner**

### What Will Stay Forever:
```
~/.ssh/        ← SSH security requirement
~/.zshrc       ← Shell startup
~/.docker/     ← Docker tooling
~/.npm/        ← Node package manager
~/.kube/       ← Kubernetes config
~/.aws/        ← AWS CLI
~/.gitconfig   ← Git (can move but traditional)
~/.viminfo     ← Vim (unless using Neovim)
+ a few others
```

### Success Metrics:
- ✅ Backups deleted
- ✅ Large app data moved to `~/.local/share/`
- ✅ Configs in `~/.config/` where supported
- ✅ Understanding which dotfiles serve what purpose
- ✅ Clean `ls ~/` output (mostly visible directories)

---

## Commands to Run Now

### 1. See Your Dotfile Count

```bash
ls -ad ~/.* | grep -v "^\.$\|^\.\.$" | wc -l
```

### 2. Clean Up Backups

```bash
rm ~/.*.backup ~/.*.bak
rm -rf ~/.vscode_extensions_backup_*
```

### 3. Move Git to XDG

```bash
mkdir -p ~/.config/git
[ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.config/git/config
[ -f ~/.gitignore_global ] && mv ~/.gitignore_global ~/.config/git/ignore
```

### 4. Verify Git Still Works

```bash
git config --list  # Should show your settings
git config user.email  # Should show your email
```

---

## Conclusion

**Can ALL dotfiles be moved?** No.

**Can MOST dotfiles be moved?** Yes, with effort.

**Should ALL dotfiles be moved?** No - diminishing returns.

**Best Approach:**
1. ✅ Clean up obvious junk (backups, .DS_Store)
2. ✅ Move large app data to `~/.local/share/`
3. ✅ Use XDG for new configs
4. ✅ Accept that 15-20 essential dotfiles will stay
5. ✅ Focus on organization, not elimination

**Your Next Step:** Run the cleanup commands above and reclaim 30-40% of your dotfile clutter! 🎯
