#!/usr/bin/env bats
# Validation tests for chezmoi scripts

@test "all chezmoiscripts have shebang" {
  for script in "$BATS_TEST_DIRNAME"/../.chezmoiscripts/*.tmpl; do
    first_line=$(head -1 "$script")
    # Allow template conditionals before shebang
    if [[ "$first_line" == '{{-'* ]]; then
      second_line=$(sed -n '2p' "$script")
      [[ "$second_line" == '#!'* ]] || {
        echo "Missing shebang in $script (after template conditional)"
        return 1
      }
    else
      [[ "$first_line" == '#!'* ]] || {
        echo "Missing shebang in $script"
        return 1
      }
    fi
  done
}

@test "all chezmoiscripts use env bash" {
  for script in "$BATS_TEST_DIRNAME"/../.chezmoiscripts/*.tmpl; do
    # Extract shebang (may be line 1 or 2 if template conditional is first)
    shebang=$(grep -m1 '^#!' "$script")
    [[ "$shebang" == '#!/usr/bin/env bash' ]] || {
      echo "Expected '#!/usr/bin/env bash' in $script, got: $shebang"
      return 1
    }
  done
}

@test "all executables have shebang" {
  for script in "$BATS_TEST_DIRNAME"/../dot_local/bin/executable_*; do
    first_line=$(head -1 "$script")
    [[ "$first_line" == '#!'* ]] || {
      echo "Missing shebang in $script"
      return 1
    }
  done
}

@test "no shell scripts use #!/bin/bash" {
  count=$(grep -rl '#!/bin/bash' "$BATS_TEST_DIRNAME"/.. --include='*.sh' --include='*.tmpl' --include='executable_*' 2>/dev/null | grep -v '.git/' | wc -l | tr -d ' ')
  [ "$count" -eq 0 ] || {
    echo "Found $count scripts still using #!/bin/bash:"
    grep -rl '#!/bin/bash' "$BATS_TEST_DIRNAME"/.. --include='*.sh' --include='*.tmpl' --include='executable_*' 2>/dev/null | grep -v '.git/'
    return 1
  }
}
