#!/bin/bash
# Kitty Theme Switcher with fzf picker
# Usage: theme-switcher.sh [theme-name]

THEMES_DIR="$HOME/.config/kitty/themes"

# List available themes (strip .conf extension)
list_themes() {
    ls -1 "$THEMES_DIR"/*.conf 2>/dev/null | xargs -n1 basename | sed 's/\.conf$//'
}

# Apply theme to current kitty window
apply_theme() {
    local theme="$1"
    local theme_file="$THEMES_DIR/${theme}.conf"

    if [[ -f "$theme_file" ]]; then
        kitty @ set-colors "$theme_file"
        echo "Applied theme: $theme"
    else
        echo "Theme not found: $theme"
        echo "Available themes:"
        list_themes
        return 1
    fi
}

# Main logic
if [[ -n "$1" ]]; then
    # Direct theme name provided
    apply_theme "$1"
else
    # Interactive fzf picker
    if ! command -v fzf &>/dev/null; then
        echo "fzf not found. Install fzf or provide theme name directly."
        echo "Available themes:"
        list_themes
        exit 1
    fi

    selected=$(list_themes | fzf \
        --prompt="Select theme: " \
        --header="Kitty Theme Switcher" \
        --preview="cat $THEMES_DIR/{}.conf | head -50" \
        --preview-window=right:50%:wrap \
        --height=60% \
        --border=rounded)

    if [[ -n "$selected" ]]; then
        apply_theme "$selected"
    fi
fi
