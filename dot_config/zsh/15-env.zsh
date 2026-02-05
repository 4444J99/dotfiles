# ─────────────────────────────────────────────────────────────────────────────
# Environment Variables
# ─────────────────────────────────────────────────────────────────────────────

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Gemini CLI Configuration
export GEMINI_CLI=1

# ─────────────────────────────────────────────────────────────────────────────
# XDG Base Directories
# ─────────────────────────────────────────────────────────────────────────────

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# ─────────────────────────────────────────────────────────────────────────────
# Application-specific XDG compliance
# Force various tools to respect XDG Base Directories
# ─────────────────────────────────────────────────────────────────────────────

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# Go
export GOPATH="$HOME/go"

# Project directories
export PROJECTS_DIR="$HOME/Projects"

# Context system
export FILE_CONTEXT_DIR="$HOME/.local/share/file-context"
