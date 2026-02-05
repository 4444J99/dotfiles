# ─────────────────────────────────────────────────────────────────────────────
# Tool Initializations
# ─────────────────────────────────────────────────────────────────────────────

# 1Password Secrets (load early for API keys)
if [[ -f "$HOME/.config/op/secrets.zsh" ]]; then
  source "$HOME/.config/op/secrets.zsh"
fi

# Starship prompt
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Zoxide (smart cd)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# fzf (fuzzy finder)
if command -v fzf &>/dev/null; then
  # Set up fzf key bindings and fuzzy completion (cached for faster startup)
  _fzf_cache="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-zsh.zsh"
  if [[ ! -f "$_fzf_cache" ]] || [[ "$(command -v fzf)" -nt "$_fzf_cache" ]]; then
    mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
    fzf --zsh > "$_fzf_cache" 2>/dev/null
  fi
  source "$_fzf_cache"
  unset _fzf_cache

  # Use fd for fzf if available (respects .gitignore)
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi

  # fzf appearance - Tokyo Night theme
  export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border=rounded
    --info=inline
    --preview-window=right:50%:wrap
    --color=bg+:#33467c,bg:#1a1b26,spinner:#7dcfff,hl:#7aa2f7
    --color=fg:#c0caf5,header:#7aa2f7,info:#e0af68,pointer:#7dcfff
    --color=marker:#9ece6a,fg+:#c0caf5,prompt:#bb9af7,hl+:#7aa2f7
    --color=border:#3b4261
    --pointer="▶"
    --marker="✓"
  '

  # Preview files with bat if available
  if command -v bat &>/dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
  fi
fi

# Atuin (shell history)
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# direnv (directory-specific environments)
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# mise (tool version manager)
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Lazy-loaded tools (deferred until first use to reduce startup time)
# ─────────────────────────────────────────────────────────────────────────────

# Anaconda / Conda - lazy load on first `conda` call
if [[ -d "/opt/anaconda3" ]]; then
  conda() {
    unfunction conda
    __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
    if [[ $? -eq 0 ]]; then
      eval "$__conda_setup"
    else
      export PATH="/opt/anaconda3/bin:$PATH"
    fi
    unset __conda_setup
    conda "$@"
  }
fi

# navi (interactive cheatsheet) - lazy load on Ctrl+G
if command -v navi &>/dev/null; then
  _navi_init() {
    eval "$(navi widget zsh)"
    zle navi-widget 2>/dev/null || true
  }
  zle -N _navi_init
  bindkey '^G' _navi_init
fi

# Google Cloud SDK - lazy load on first `gcloud` call
if [[ -d "$HOME/google-cloud-sdk" ]]; then
  gcloud() {
    unfunction gcloud
    [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/google-cloud-sdk/path.zsh.inc"
    [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"
    gcloud "$@"
  }
fi
