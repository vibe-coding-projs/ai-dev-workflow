# AI Dev Workflow

Config and scripts for a Jira → Claude Code → GitHub → Render preview workflow.

## How it works

```
PM creates Jira ticket (e.g. DMP-1)
       ↓
Run: ./scripts/work-on-ticket.sh DMP-1
       ↓
Repo is cloned/pulled automatically
       ↓
Claude Code session opens with ticket context
       ↓
Claude reads ticket (via Jira MCP), sets status to In Progress, writes code, opens PR
       ↓
Claude updates Jira ticket with PR link + preview URL
       ↓
PM reviews preview URL → Dev merges → Prod deploy
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
