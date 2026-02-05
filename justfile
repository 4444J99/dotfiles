# Domus Semper Palingenesis - Task Runner
# Usage: just <recipe> or j <recipe>

# Default: show status
default:
    @domus status

# Apply dotfiles and packages
apply:
    chezmoi apply

# Preview changes without applying
diff:
    chezmoi diff

# Run all linters
lint:
    @echo ":: ShellCheck"
    @find dot_local/bin -name 'executable_*' ! -name '*.tmpl' -exec shellcheck -x {} + 2>/dev/null || true
    @echo ""
    @echo ":: YAML lint"
    @find . -name '*.yml' -o -name '*.yaml' | grep -v '.git/' | xargs yamllint -c .yamllint.yml 2>/dev/null || true
    @echo ""
    @echo ":: JSON validation"
    @find . -name '*.json' ! -path './.git/*' ! -name '*.tmpl' -exec python3 -m json.tool {} > /dev/null \; 2>/dev/null && echo "All JSON valid" || true

# Run tests (requires bats)
test:
    @echo ":: Template validation"
    @bash tests/test-templates.sh
    @echo ""
    @if command -v bats >/dev/null 2>&1; then \
        echo ":: BATS tests"; \
        bats tests/*.bats; \
    else \
        echo ":: BATS not installed (brew install bats-core)"; \
    fi

# Health check
health:
    chezmoi-health

# Full system check
doctor:
    domus doctor

# Update from remote
update:
    chezmoi update

# Show package drift
packages-diff:
    domus packages diff

# Format shell scripts
fmt:
    @find dot_local/bin -name 'executable_*' ! -name '*.tmpl' -exec shfmt -w -i 2 -ci {} + 2>/dev/null || echo "shfmt not found (brew install shfmt)"

# Validate templates
template-check:
    @bash tests/test-templates.sh

# Dry run chezmoi apply
dry-run:
    chezmoi apply --dry-run

# Show shell startup performance
perf:
    domus perf shell

# Open dotfiles in editor
edit:
    $EDITOR ~/dotfiles
