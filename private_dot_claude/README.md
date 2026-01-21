# Claude Code Configuration

Configuration for [Claude Code](https://claude.ai/claude-code) CLI tool.

## Template Interceptor

Solves the issue where Claude Code encounters 400 errors ("Output blocked by content filtering policy") when generating files like `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, etc.

### How It Works

A PreToolUse hook intercepts Write operations for specific filenames and replaces the content with official templates before the write executes.

```
Claude Write → Hook intercepts → Template injected → Write succeeds
```

### Files

- `scripts/template-interceptor.sh` - Hook script that intercepts writes
- `templates/config.json` - Configuration for which files to intercept
- `templates/CODE_OF_CONDUCT.md` - Contributor Covenant v2.1
- `templates/CONTRIBUTING.md` - Contributing guidelines template
- `templates/SECURITY.md` - Security policy template

### Required settings.json Configuration

Add this to `~/.claude/settings.json` (merge with existing):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/template-interceptor.sh"
          }
        ]
      }
    ]
  }
}
```

### Adding New Templates

1. Add template file to `templates/`
2. Add entry to `templates/config.json`:
   ```json
   "YOUR_FILE.md": {
     "source": "local",
     "path": "YOUR_FILE.md"
   }
   ```

### Placeholders

Templates support automatic placeholder substitution:

| Placeholder | Source |
|-------------|--------|
| `{{PROJECT_NAME}}` | Git remote or directory name |
| `{{CONTACT_EMAIL}}` | Git config `user.email` |
| `{{YEAR}}` | Current year |

## Note

After chezmoi applies these files, restart Claude Code for hooks to take effect.
