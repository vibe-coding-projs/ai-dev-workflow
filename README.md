# AI Dev Workflow

Config and scripts for a Jira → Claude Code → GitHub → Render preview workflow.

## How it works

```
PM creates Jira ticket (e.g. DMP-42)
       ↓
Run: ./scripts/work-on-ticket.sh DMP-42
       ↓
Repo is cloned/pulled automatically
       ↓
Claude Code session opens with ticket context
       ↓
Claude reads ticket (via Jira MCP), writes code, opens PR
       ↓
Render preview env spins up automatically
       ↓
PM reviews preview URL → Dev merges → Prod deploy
```

## Setup (once per machine)

```bash
git clone https://github.com/vibe-coding-projs/ai-dev-workflow.git
cd ai-dev-workflow
./install.sh
```

The install script will prompt you for your tokens and write them automatically to `~/Library/Application Support/Claude/claude_desktop_config.json`.

You'll need:
- `GITHUB_PERSONAL_ACCESS_TOKEN` — [GitHub Settings → Tokens](https://github.com/settings/tokens)
- `JIRA_HOST` — e.g. `https://your-org.atlassian.net`
- `JIRA_EMAIL` — your Atlassian email
- `JIRA_API_TOKEN` — [Atlassian API Tokens](https://id.atlassian.com/manage-profile/security/api-tokens)

> Note: Claude Desktop uses two separate files:
> - `config.json` — internal preferences (do not edit)
> - `claude_desktop_config.json` — MCP servers config (this is what the install script writes)

## Working on a ticket

```bash
./scripts/work-on-ticket.sh DMP-42
```

## Adding a new project

Edit `config/project-mapping.yaml`:

```yaml
projects:
  DMP:
    repo: vibe-coding-projs/dumb-music-player
    branch: main
    local_path: ~/projects/dumb-music-player
```

## Files

| File | Purpose |
|---|---|
| `scripts/work-on-ticket.sh` | Pull repo + open Claude Code session |
| `config/project-mapping.yaml` | Jira project → GitHub repo mapping |
| `mcp/claude_desktop_config.json` | MCP config template for Claude Desktop |
| `install.sh` | One-time setup script |
