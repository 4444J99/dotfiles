# 1Password-backed secrets with caching for fast shell startup.
# Loads secrets instantly from cache, refreshes in background when stale.
# Cache file: ~/.cache/op-secrets (mode 600, encrypted at rest via FileVault)

_OP_CACHE="${HOME}/.cache/op-secrets"
_OP_CACHE_MAX_AGE=60  # minutes

_op_cache_refresh() {
  # Only refresh if op is available
  command -v op >/dev/null 2>&1 || return 1

  mkdir -p "$(dirname "$_OP_CACHE")"
  {
    echo "GEMINI_API_KEY=$(op read 'op://Personal/Gemini API Key/credential' 2>/dev/null)"
    echo "GITHUB_TOKEN=$(op read 'op://Personal/antigravity--github-api--112525/token' 2>/dev/null)"
    echo "NPM_TOKEN=$(op read 'op://Personal/NPM Token/credential' 2>/dev/null)"
  } > "$_OP_CACHE.tmp" && mv "$_OP_CACHE.tmp" "$_OP_CACHE"
  chmod 600 "$_OP_CACHE"
}

# Load from cache (instant)
if [[ -f "$_OP_CACHE" ]]; then
  source "$_OP_CACHE"
  # Export aliases
  export GEMINI_API_KEY GITHUB_TOKEN NPM_TOKEN
  export GOOGLE_API_KEY="$GEMINI_API_KEY"
  export GITHUB_MCP_PAT="$GITHUB_TOKEN"
  export GH_TOKEN="$GITHUB_TOKEN"
  export NODE_AUTH_TOKEN="$NPM_TOKEN"
fi

# Refresh cache in background if stale (>1 hour old) or missing
if [[ ! -f "$_OP_CACHE" ]] || [[ -n "$(find "$_OP_CACHE" -mmin +${_OP_CACHE_MAX_AGE} 2>/dev/null)" ]]; then
  ( _op_cache_refresh & ) 2>/dev/null
fi
