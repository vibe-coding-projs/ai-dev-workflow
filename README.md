# AI Dev Workflow

Config and scripts for a Jira → Claude Code → GitHub → Render preview workflow.

## How it works

```
PM creates Jira ticket (e.g. DMP-1)
       ↓
Run: ./scripts/work-on-ticket.sh DMP-1
       ↓
Claude reads ticket → sets to In Progress → creates branch
       ↓
Claude implements + posts Jira comment per change
       ↓
Claude opens PR → sets ticket to In Review → posts PR link + preview URL to Jira
       ↓
PM reviews Render preview → moves ticket to PM Approved
       ↓
Dev team / code review agents review PR on GitHub
       ↓
Dev merges PR → Render auto-deploys to prod → ticket moves to Done
```

## Setup (once per machine)

```bash
git clone https://github.com/vibe-coding-projs/ai-dev-workflow.git
cd ai-dev-workflow
./install.sh
```

The install script will:
1. Prompt you for your tokens
2. Configure MCPs for both **Claude Desktop** and **Claude Code CLI** (user-scoped, applies across all repos)
3. Copy the global `CLAUDE.md` to `~/.claude/CLAUDE.md` so Claude follows the workflow rules in every session

You'll need:
- `GITHUB_PERSONAL_ACCESS_TOKEN` — [GitHub Settings → Tokens](https://github.com/settings/tokens)
- `JIRA_URL` — e.g. `https://your-org.atlassian.net`
- `JIRA_EMAIL` — your Atlassian email
- `JIRA_API_TOKEN` — [Atlassian API Tokens](https://id.atlassian.com/manage-profile/security/api-tokens)

> Note: Claude Desktop uses two separate files:
> - `config.json` — internal preferences (do not edit)
> - `claude_desktop_config.json` — MCP servers config (this is what the install script writes)

## Working on a ticket

```bash
./scripts/work-on-ticket.sh DMP-1
```

Claude will automatically:
- Read the Jira ticket
- Set ticket status to **In Progress**
- Create a branch, write code, open a PR
- Set ticket status to **In Review** with PR link + preview URL
- Output a handoff block for team continuity

## Adding a new project

Edit `config/project-mapping.yaml`:

```yaml
projects:
  DMP:
    jira_url: https://vibe-coding-projects.atlassian.net/jira/software/projects/DMP/boards/1
    repo: vibe-coding-projs/dumb-music-player
    branch: main
    local_path: ~/projects/dumb-music-player
```

## Files

| File | Purpose |
|---|---|
| `scripts/work-on-ticket.sh` | Pull repo + open Claude Code session |
| `config/project-mapping.yaml` | Jira project → GitHub repo mapping |
| `claude/CLAUDE.md` | Global Claude Code workflow rules (copied to `~/.claude/CLAUDE.md`) |
| `mcp/claude_desktop_config.json` | MCP config template for Claude Desktop |
| `install.sh` | One-time setup script |
