# Global Agent Instructions

Global policy: /Users/4jp/AGENTS.md applies and cannot be overridden.

This file applies to all projects under `/Users/4jp` and is mandatory. If a project has its own `AGENTS.md`, follow both, but this global secrets policy cannot be overridden.

## Secrets Policy (Global)
- All secrets must live in 1Password. Do not store API keys, tokens, or credentials in plaintext files, repo configs, or shell RCs.
- Use `op read` or 1Password-backed loaders for environment variables:
  - Shell: `~/.config/op/secrets.zsh`
  - Project env: `~/.config/op/load-env.sh` and per-project `*.env.op.sh`
- If a secret is discovered outside 1Password, migrate it immediately and replace usage with 1Password-backed loading.

## Additional Guidance
- Also follow `/Users/4jp/System/Guides/AGENTS.md` for general development conventions and workspace practices.
