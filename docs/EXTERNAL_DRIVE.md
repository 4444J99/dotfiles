# External Drive Integration Guide

## Current Setup

**External Drive:** `/Volumes/4444-iivii`
**Status:** Currently unmounted
**Auto-Detection:** ✅ Enabled in setup script

## What Happens When You Connect the Drive

When you connect your external drive, the chezmoi setup script automatically:

1. **Creates stable symlink:** `~/External → /Volumes/4444-iivii`
2. **Links workspace:** `~/Projects/ivi374 → ~/External/ivi374forivi3ivi3/workspace`
3. **Links toolchains:** `~/.local/share/toolchains → ~/External/ivi374forivi3ivi3/toolchains`

These symlinks make paths stable and portable.

## Testing the Setup

```bash
# 1. Connect your external drive

# 2. Run chezmoi setup (if not auto-run)
chezmoi apply

# 3. Verify symlinks created
ls -la ~/External
ls -la ~/Projects/ivi374
ls -la ~/.local/share/toolchains

# 4. Check drive status
file-org check-external

# 5. Test PATH
echo $PATH | grep toolchains  # Should show toolchains in PATH
```

## Manual Symlink Creation

If auto-detection doesn't work or you need custom symlinks:

```bash
# Main drive symlink
ln -sf /Volumes/4444-iivii ~/External

# Workspace symlink
ln -sf ~/External/ivi374forivi3ivi3/workspace ~/Projects/ivi374

# Toolchains symlink
ln -sf ~/External/ivi374forivi3ivi3/toolchains ~/.local/share/toolchains

# Custom project symlink
ln -sf ~/External/some-project ~/Projects/Active/shortcut-name
```

## PATH Configuration

Your `.zshrc` is already configured to handle the external drive gracefully:

```bash
# Conditional check - doesn't break if drive unmounted
if [ -d "/Volumes/4444-iivii/ivi374forivi3ivi3/toolchains/bin" ]; then
  export PATH="$PATH:/Volumes/4444-iivii/ivi374forivi3ivi3/toolchains/bin"
fi
```

## Troubleshooting

### Drive Not Auto-Detected

**Problem:** Symlinks not created automatically

**Solutions:**
```bash
# Check if drive is mounted
ls /Volumes/

# If mounted at different path, update symlink
rm ~/External
ln -sf /Volumes/ACTUAL-NAME ~/External

# Re-run setup
chezmoi apply
```

### Broken Symlinks

**Problem:** `ls ~/External` shows "No such file or directory"

**Cause:** Drive unmounted (this is normal!)

**Fix:** Reconnect drive, symlinks will work again

### Toolchains Not in PATH

**Problem:** Commands from toolchains not found

**Check:**
```bash
# 1. Is drive mounted?
file-org check-external

# 2. Does symlink exist?
ls -la ~/.local/share/toolchains

# 3. Is PATH configured?
echo $PATH | grep toolchains

# 4. Reload shell config
source ~/.zshrc
```

## Best Practices

### ✅ DO:
- Use `~/External` instead of `/Volumes/4444-iivii` in scripts
- Use `~/.local/share/toolchains` instead of full external path
- Check if drive mounted before accessing: `[ -d ~/External ]`
- Document custom symlinks in project manifest

### ❌ DON'T:
- Hardcode `/Volumes/4444-iivii` paths
- Assume drive is always mounted
- Delete `~/External` symlink (just a pointer, not the actual files)
- Store critical files ONLY on external drive (back up to cloud)

## Multiple Machines

If you have multiple machines with the same external drive:

```bash
# Machine 1 (MacBook)
ln -sf /Volumes/4444-iivii ~/External

# Machine 2 (iMac) - might mount at different name
ln -sf /Volumes/4444-iivii ~/External  # Same!

# Machine 3 (Linux) - different mount point entirely
ln -sf /media/4444-iivii ~/External    # But ~/External still works!
```

The symlink approach means your scripts and configs can use `~/External` everywhere, regardless of the actual mount point.

## Archive Strategy

When archiving projects to external drive:

```bash
# 1. Move completed project to external archive
mv ~/Projects/Active/old-project ~/External/Archive/Projects/2024/

# 2. Update project manifest
# Edit: ~/.local/share/file-context/manifests/projects.yaml
# Change status to "archived" and update path

# 3. Optional: Create reference symlink
ln -sf ~/External/Archive/Projects/2024/old-project ~/Projects/Archive/old-project-ref

# 4. Remove from active workspace
# Already done in step 1!
```

## Current External Drive Contents

Based on your `.gitconfig` and `.zshrc`:

```
/Volumes/4444-iivii/
├── ivi374forivi3ivi3/
│   ├── workspace/          → ~/Projects/ivi374 (symlink)
│   └── toolchains/         → ~/.local/share/toolchains (symlink)
│       └── bin/           → Added to PATH
└── (other folders)
```

**Safe directories** configured in git:
- `/Volumes/4444-iivii`
- `/Volumes/4444-iivii/ivi374forivi3ivi3/workspace`
- `/Volumes/4444-iivii/ivi374forivi3ivi3`

## Next Steps

1. **Connect your drive** - Symlinks will auto-create
2. **Verify with:** `file-org check-external`
3. **Test PATH:** `echo $PATH | grep toolchains`
4. **Document custom links** - Add to project manifest if you create more
