# AI Development Tools Guide

Overview of AI-assisted development tools and when to use each.

## Tool Comparison

| Tool | Model | Best For | Strengths |
|------|-------|----------|-----------|
| **Claude Code** | Opus 4.5 | Complex coding, refactoring | Deep reasoning, large context, plan mode |
| **Goose** | Gemini 2.5 Pro + Opus 4.1 | Autonomous tasks, browser automation | Router mode, MCP extensions, persistent memory |
| **Gemini CLI** | Gemini 2.5 Pro | Quick questions, Google ecosystem | Fast responses, direct API access |
| **OpenCode** | Various | Light editing, quick fixes | Simple interface, multiple providers |

## When to Use Each Tool

### Claude Code (`claude`)

Best for:
- Complex multi-file refactoring
- Architecture planning (use plan mode)
- Deep code understanding and explanation
- Writing comprehensive tests
- Security-sensitive implementations
- Tasks requiring careful reasoning

Key features:
- Opus 4.5 model with deep reasoning
- Plan mode for complex implementations
- Git integration with `/commit` skill
- Extensive file editing capabilities
- MCP server support (Context7, Playwright, Neon, etc.)

```bash
# Start Claude Code
claude

# Useful commands
/help          # Show all commands
/plan          # Enter plan mode
/commit        # Commit with AI-generated message
/review-pr     # Review a pull request
```

### Goose (`goose`)

Best for:
- Autonomous multi-step workflows
- Browser automation via Playwright
- Tasks requiring persistent memory
- Working with PDFs and documentation
- Exploratory research

Key features:
- Router mode (Gemini 2.5 Pro default, Opus 4.1 for complex tasks)
- Extensive MCP extensions (Playwright, Context7, PDF Reader, Repomix)
- Knowledge graph memory for cross-session context
- Built-in todo list for task tracking
- Session recall for continuing previous work

```bash
# Start Goose
goose

# Session management
goose session list
goose session resume <id>
```

Active extensions:
- `developer` - Core development tools
- `context7` - Up-to-date code/docs lookup
- `playwright` - Browser automation
- `pdfreader` - PDF document parsing
- `repomix` - Repository analysis
- `memory` - Persistent preferences
- `knowledgegraphmemory` - Graph-based memory

### Gemini CLI (`gemini`)

Best for:
- Quick one-off questions
- Google-specific integrations
- When speed matters more than depth
- Simple explanations

```bash
# Quick question
gemini "How do I..."

# Interactive mode
gemini
```

### OpenCode

Best for:
- Quick file edits
- When you need a simpler interface
- Experimentation with different models

Config: `~/.config/opencode/opencode.json`

## Model Selection Guide

| Task Type | Recommended Tool | Why |
|-----------|-----------------|-----|
| Large refactor | Claude Code | Plan mode, deep reasoning |
| Browser testing | Goose | Playwright integration |
| Quick fix | Gemini CLI or OpenCode | Speed |
| Documentation | Goose | PDF reader, memory |
| Security review | Claude Code | Careful analysis |
| API integration | Claude Code | Context understanding |
| Research/exploration | Goose | Browser + memory |
| Git operations | Claude Code | Built-in skills |

## MCP Servers Overview

MCP (Model Context Protocol) provides tools and capabilities to AI assistants.

### Available in Claude Code:
- **Context7** - Library documentation lookup
- **Playwright** - Browser automation
- **Neon** - PostgreSQL database operations
- **Serena** - Semantic code analysis
- **Docker MCP** - Container management, GitHub operations

### Available in Goose:
- **Context7** - Library documentation
- **Playwright** - Browser automation
- **PDF Reader** - Document parsing
- **Repomix** - Repository analysis
- **Knowledge Graph Memory** - Persistent memory
- **GitMCP** - GitHub documentation
- **Pieces** - Long-term memory (requires Pieces app)

## Tips

1. **Start with Claude Code** for coding tasks - it has the best reasoning for code.

2. **Use Goose for autonomy** - when you want the AI to work independently across multiple steps.

3. **Plan mode is your friend** - for anything non-trivial in Claude Code, start with `/plan`.

4. **Check Goose sessions** - if you worked on something before, you can resume the session.

5. **Memory matters** - Goose remembers preferences across sessions. Teach it once.

6. **MCP servers need startup** - some tools (Docker MCP) need background services running.

## API Keys (via 1Password)

All API keys are managed through 1Password and loaded via:
- `~/.config/op/secrets.zsh` (zsh)
- `~/.config/op/secrets.fish` (fish - if exists)

Keys include:
- `ANTHROPIC_API_KEY` - Claude
- `GOOGLE_AI_API_KEY` / `GEMINI_API_KEY` - Gemini
- `OPENAI_API_KEY` - OpenAI (if used)
- Various provider-specific keys via Tetrate router
