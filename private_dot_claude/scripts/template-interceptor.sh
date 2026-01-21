#!/bin/bash
# Template Interceptor for Claude Code
# Intercepts Write operations for certain files and replaces content with official templates
# Configurable via ~/.claude/templates/config.json

set -euo pipefail

CONFIG_FILE="$HOME/.claude/templates/config.json"
TEMPLATES_DIR="$HOME/.claude/templates"

# Read JSON input from stdin
INPUT=$(cat)

# Extract file_path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# If no file path, approve and exit
if [[ -z "$FILE_PATH" ]]; then
  echo '{"decision": "approve"}'
  exit 0
fi

FILENAME=$(basename "$FILE_PATH" 2>/dev/null)

# Check if config exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo '{"decision": "approve"}'
  exit 0
fi

# Check if this filename is in our templates
TEMPLATE_CONFIG=$(jq -r --arg fn "$FILENAME" '.templates[$fn] // empty' "$CONFIG_FILE")

if [[ -z "$TEMPLATE_CONFIG" ]]; then
  echo '{"decision": "approve"}'
  exit 0
fi

# Get template path
TEMPLATE_PATH=$(echo "$TEMPLATE_CONFIG" | jq -r '.path // empty')
FULL_PATH="$TEMPLATES_DIR/$TEMPLATE_PATH"

# If template doesn't exist locally, try to fetch from URL
if [[ ! -f "$FULL_PATH" ]]; then
  URL=$(echo "$TEMPLATE_CONFIG" | jq -r '.url // empty')
  if [[ -n "$URL" ]]; then
    curl -sf "$URL" -o "$FULL_PATH" 2>/dev/null || true
  fi
fi

# If we have a template file, use it
if [[ -f "$FULL_PATH" ]]; then
  # Read template content
  CONTENT=$(cat "$FULL_PATH")

  # Auto-detect project name from git remote or directory
  if git rev-parse --show-toplevel &>/dev/null; then
    # Try to get from git remote
    REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")
    if [[ -n "$REMOTE_URL" ]]; then
      # Extract repo name from URL (handles both HTTPS and SSH)
      PROJECT_NAME=$(echo "$REMOTE_URL" | sed 's/.*\///' | sed 's/\.git$//')
    else
      PROJECT_NAME=$(basename "$(git rev-parse --show-toplevel)")
    fi
  else
    PROJECT_NAME=$(basename "$(pwd)")
  fi
  CONTENT="${CONTENT//\{\{PROJECT_NAME\}\}/$PROJECT_NAME}"

  # Auto-detect email from git config
  EMAIL=$(git config user.email 2>/dev/null || echo "contact@example.com")
  CONTENT="${CONTENT//\{\{CONTACT_EMAIL\}\}/$EMAIL}"

  # Current year
  CONTENT="${CONTENT//\{\{YEAR\}\}/$(date +%Y)}"

  # Escape content for JSON output
  # Using jq to properly escape the content
  CONTENT_JSON=$(printf '%s' "$CONTENT" | jq -Rs .)

  # Return updated input with template content
  echo "{\"decision\": \"approve\", \"updatedInput\": {\"content\": $CONTENT_JSON}, \"systemMessage\": \"Using template for $FILENAME (from ~/.claude/templates/)\"}"
  exit 0
fi

# Template not found - allow original content (may fail with content filter)
echo '{"decision": "approve"}'
