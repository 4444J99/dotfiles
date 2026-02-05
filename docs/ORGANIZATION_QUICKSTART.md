# File Organization - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Run the Setup (Already Done by Chezmoi)

The organization structure is created automatically when chezmoi runs.

### Step 2: Inventory Your Files

```bash
# See what you have
file-org inventory

# Find files that shouldn't be in home root
file-org clean-root

# Check external drive status
file-org check-external
```

### Step 3: Move Files to Proper Locations

**Quick Reference - Where Things Go:**

| What | Where | Example |
|------|-------|---------|
| Notes/Markdown | `~/Documents/Notes/` | `AGENTS.md` → `~/Documents/Notes/AGENTS.md` |
| Active Projects | `~/Projects/Active/` | `my-app/` → `~/Projects/Active/my-app/` |
| Old Projects | `~/Projects/Archive/` or `~/External/Archive/Projects/` | |
| Random JSON/config | Find the project it belongs to, or delete | `package-lock.json` → project folder or delete |
| Log files | `~/.local/state/[app]/` | `firebase-debug.log` → `~/.local/state/firebase/` or delete |
| System backups | `~/External/Archive/System/` | Move old `~/System/` folder |

### Step 4: Create Stable Symlinks for External Drive

```bash
# Main symlink (auto-created if drive mounted)
ls -la ~/External  # Should point to /Volumes/4444-iivii

# Create additional symlinks as needed
ln -s ~/External/some-folder ~/Projects/shortcut-name
```

### Step 5: Update Your Paths

Your `.zshrc` is already updated with:
- ✅ Conditional checks for external drives
- ✅ Graceful fallbacks if drive not mounted

---

## 📊 Your New Directory Structure

```
~/
├── .config/              # ← Configurations
├── .local/
│   ├── bin/             # ← Your scripts (file-org is here!)
│   ├── share/           # ← App data & context system
│   │   ├── file-context/
│   │   │   ├── manifests/     # Describe your files
│   │   │   └── links/         # Organized by type/project
│   │   └── toolchains/ →      # Symlink to external
│   └── state/           # ← Logs, history
│
├── Projects/
│   ├── Active/          # ← Current work
│   ├── Archive/         # ← Old local projects
│   └── ivi374 →         # ← Symlink to external workspace
│
├── Documents/
│   ├── Work/
│   ├── Personal/
│   ├── Notes/           # ← Put your AGENTS.md here!
│   └── Archive/
│
└── External →           # ← Stable link to /Volumes/4444-iivii/
```

---

## 🔧 Practical Examples

### Example 1: Organize That Random File in Root

```bash
# You have: ~/AGENTS.md
# Where does it go?

# Is it a note? Move to Notes:
mv ~/AGENTS.md ~/Documents/Notes/

# Is it project-specific? Move to project:
mv ~/AGENTS.md ~/Projects/Active/some-project/docs/

# Is it reference material? Archive it:
mv ~/AGENTS.md ~/Documents/Archive/notes-$(date +%Y)/
```

### Example 2: Create Project Symlinks

```bash
# You have an external project you work on often
# Instead of: cd /Volumes/4444-iivii/ivi374forivi3ivi3/workspace
# Create: ~/Projects/ivi374 → (symlink)

ln -s ~/External/ivi374forivi3ivi3/workspace ~/Projects/ivi374

# Now just: cd ~/Projects/ivi374
```

### Example 3: Track Files with Manifests

```bash
# Create a manifest for your projects
cat > ~/.local/share/file-context/manifests/my-projects.yaml <<'EOF'
projects:
  active:
    - name: "dotfiles"
      path: "~/Projects/Active/dotfiles"
      type: "system"
      priority: "critical"
      backup: "GitHub + ~/External/Archive/"

    - name: "ivi374-workspace"
      path: "~/Projects/ivi374"
      actual_location: "~/External/ivi374forivi3ivi3/workspace"
      type: "development"
      storage: "external"
      size: "large"

  archived:
    - name: "old-experiment-2023"
      path: "~/External/Archive/Projects/2023/old-experiment"
      why_archived: "Completed, keeping for reference"
      tags: ["python", "ml", "reference"]
EOF

# Now you have documentation of what's where and why!
```

### Example 4: Find Duplicates

```bash
# Install rmlint
brew install rmlint

# Find duplicate files
rmlint ~/Documents ~/External/Archive --size 1M

# Review the script it generates (DO NOT run blindly!)
less rmlint.sh

# After review, run with dry-run
sh rmlint.sh -d
```

---

## 🎯 Common Tasks

### Clean Up Home Root

```bash
# 1. List all non-directory files in home
file-org clean-root

# 2. Categorize each file:
#    - Notes? → ~/Documents/Notes/
#    - Config? → ~/.config/[app]/
#    - Project? → ~/Projects/[project]/
#    - Log? → ~/.local/state/[app]/ or delete
#    - Temp? → Delete it

# 3. Move systematically
for file in AGENTS.md README.md; do
  echo "Moving $file..."
  # mv ~/$file ~/Documents/Notes/$file
done
```

### Migrate from ~/Workspace to ~/Projects

```bash
# 1. Review what's in Workspace
ls -la ~/Workspace/

# 2. Identify active vs archived
#    Active = worked on in last 90 days
#    Archived = older

# 3. Move active projects
mv ~/Workspace/active-project ~/Projects/Active/

# 4. Archive old projects
mv ~/Workspace/old-project ~/Projects/Archive/
# or: mv ~/Workspace/old-project ~/External/Archive/Projects/2023/

# 5. Remove empty Workspace folder
rmdir ~/Workspace
```

### Setup External Drive on New Machine

```bash
# 1. Connect external drive
# 2. Run chezmoi apply (setup script runs automatically)
chezmoi apply

# 3. Verify symlinks created
ls -la ~/External
ls -la ~/Projects/ivi374
ls -la ~/.local/share/toolchains

# 4. Your PATH is already configured!
echo $PATH | grep toolchains
```

---

## 🛟 Troubleshooting

### "External drive symlink broken"

**Cause:** Drive not mounted

**Fix:**
```bash
# Check if drive mounted
ls /Volumes/

# If mounted at different location, update symlink
rm ~/External
ln -s /Volumes/NEW-NAME ~/External
```

### "Too many files, where do I start?"

**Answer:** Start with the biggest offenders

```bash
# Find largest directories
du -sh ~/* 2>/dev/null | sort -hr | head -10

# Start with those, one at a time:
# 1. Library (85GB) - Leave alone (system files)
# 2. Pictures (10GB) - Keep, maybe archive old years
# 3. Documents (8.7GB) - Organize into Work/Personal/Archive
# 4. Workspace (7.8GB) - Migrate to ~/Projects/
# 5. System (1.9GB) - Archive to external drive
```

### "I broke something!"

**Undo:**
```bash
# Symlinks are safe to delete
rm ~/External  # Just removes the link, not the files!

# Restore from backup
chezmoi init  # Re-run setup

# Or manually recreate
mkdir -p ~/Projects/Active
# ... etc
```

---

## 📈 Maintenance

### Weekly
```bash
# Clean Downloads folder
organize run ~/.config/organize/config.yaml  # If you set up organize-tool

# Or manually:
ls -lt ~/Downloads/ | head -20  # Review recent downloads
```

### Monthly
```bash
# Run inventory to see growth
file-org inventory

# Compare to previous month
diff ~/file-inventory-$(date -v-1m +%Y%m%d).txt ~/file-inventory-$(date +%Y%m%d).txt
```

### Quarterly
```bash
# Archive old projects
find ~/Projects/Active -type d -mtime +90  # Not modified in 90 days

# Review and move to Archive or External
```

---

## ✅ Success Checklist

After organizing, you should have:

- [ ] Clean home root (only necessary folders, no random files)
- [ ] `~/Projects/` instead of `~/Workspace/`
- [ ] Stable `~/External` symlink to external drive
- [ ] PATH works whether drive is mounted or not
- [ ] Notes organized in `~/Documents/Notes/`
- [ ] Old system files archived or deleted
- [ ] File manifests documenting your important files
- [ ] `file-org` command available for ongoing maintenance

---

## 🎓 Learn More

- Full strategy: `ORGANIZATION_STRATEGY.md`
- XDG spec: https://specifications.freedesktop.org/basedir-spec/
- File organization tools: `organize-tool`, `tmsu`, `rmlint`

**Remember:** Organization is ongoing, not one-time. The system makes it easier to stay organized!
