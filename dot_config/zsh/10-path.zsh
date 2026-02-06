# ─────────────────────────────────────────────────────────────────────────────
# PATH Configuration
# ─────────────────────────────────────────────────────────────────────────────

# macOS ARM64 (Apple Silicon) - Homebrew
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/file-formula/bin:$PATH"

# Ruby (Homebrew - macOS)
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

# Go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export PATH=$PATH:$GOPATH/bin

# Rust (rustup toolchain)
export PATH="${CARGO_HOME:-$HOME/.local/share/cargo}/bin:$PATH"

# pipx local bin
export PATH="$HOME/.local/bin:$PATH"

# Python (Homebrew - follows latest via python@3 symlink)
export PATH="/opt/homebrew/opt/python@3/libexec/bin:$PATH"

# Toolchains (External Volume - macOS only)
# Graceful fallback if external drive not mounted
if [[ -d "/Volumes/4444-iivii/ivi374forivi3ivi3/toolchains/bin" ]]; then
  export PATH=$PATH:/Volumes/4444-iivii/ivi374forivi3ivi3/toolchains/bin
fi
