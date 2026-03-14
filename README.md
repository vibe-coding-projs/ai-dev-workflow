# AI Dev Workflow

You write a Jira ticket. Claude builds it and posts a preview link for you to review — no developers needed until final code review.

---

## How it works

| Step | Who | What happens |
|---|---|---|
| 1 | PM | Writes a Jira ticket |
| 2 | PM | Runs a command to start Claude |
| 3 | Claude | Reads the ticket, builds the feature, opens a PR |
| 4 | Claude | Posts a preview URL as a Jira comment |
| 5 | PM | Reviews the preview in their browser |
| 6 | PM | Comments "Approved" on the Jira ticket, or gives feedback |
| 7 | Dev team | Reviews code and merges → feature goes live |

---

## One-time setup

### Prerequisites

Install these before running setup:

| Tool | How to install | Why |
|---|---|---|
| macOS | — | Scripts are Mac-only |
| Git | Pre-installed, or [git-scm.com](https://git-scm.com) | Clone and push repos |
| Node.js + npm | [nodejs.org](https://nodejs.org) — install LTS version | Run GitHub MCP server |
| Claude Code CLI | `npm install -g @anthropic-ai/claude-code` | Run AI coding sessions |
| Claude Pro account | [claude.ai](https://claude.ai) | Required to authenticate Claude Code |
| GitHub account | Your org's GitHub | Access to repos |
| Jira account | Your org's Atlassian workspace | Access to tickets |

Verify everything is ready:

```bash
git --version     # v2 or higher
node --version    # v18 or higher
npm --version     # v9 or higher
claude --version  # any version
```

### Credentials

Get these ready before running the install script:

| Credential | Where to get it |
|---|---|
| GitHub Personal Access Token | [github.com/settings/tokens](https://github.com/settings/tokens) — enable `repo` scope |
| Jira URL | e.g. `https://your-org.atlassian.net` |
| Jira Email | The email you use to log into Jira |
| Jira API Token | [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens) |

### Install

```bash
git clone https://github.com/vibe-coding-projs/ai-dev-workflow.git
cd ai-dev-workflow
./install.sh
```

The script will prompt for your credentials and automatically:
- Install `uv` (needed for Jira MCP)
- Configure Jira and GitHub MCPs for Claude Code CLI and Claude Desktop
- Copy workflow rules to `~/.claude/CLAUDE.md` so Claude follows the process in every session

---

## Day to day usage

### Starting work on a ticket

```bash
cd ai-dev-workflow
./scripts/work-on-ticket.sh DMP-1
```

Claude will automatically:
- Read the Jira ticket and all its comments
- Set the ticket to **In Progress**
- Create a branch, implement the feature, open a PR
- Post a Jira comment for each meaningful change
- Set the ticket to **In Review** with the PR link and preview URL
- Post a handoff block at the end of the session

### Writing a good Jira ticket

The better your ticket, the better Claude's output. Use this format:

```
## What
[One sentence: what needs to change]

## Why
[The user problem or business reason]

## Acceptance Criteria
- [ ] [Something you can visually check in the preview]
- [ ] [Another checkable thing]

## Design / references
[Figma link, screenshot, or example — if you have one]
```

**Tips:**
- Describe what you want to see, not how to build it
- Acceptance criteria should be things you can check yourself in the browser
- Screenshots and examples help a lot

### Reviewing the preview

Once Claude is done, it will post a preview URL as a Jira comment:
```
https://dmp-1-feature-name.onrender.com
```
> The preview may take 1-2 minutes to load the first time.

Open it in your browser and check against your acceptance criteria.

**If it looks good** → comment **"Approved"** on the Jira ticket. The dev team will do a final code review and ship it.

**If changes are needed:**
- **Session still open** → type your feedback directly into the Claude session. Claude iterates immediately and updates the preview.
- **Session closed** → find the handoff block in the latest Jira comment, copy it, paste it into a new Claude session, and describe what needs to change. Claude will read all previous comments and continue from where it left off.

### Resuming a closed session

1. Find the **handoff block** in the latest Jira comment
2. Copy and paste it into a new Claude Code session
3. Describe what needs to change

---

## Jira ticket statuses

| Status | Meaning |
|---|---|
| To Do | Ticket is ready to be worked on |
| In Progress | Claude is building the feature |
| In Review | Preview is ready for you to review |
| In Review + "Approved" comment | Signed off, waiting for dev merge |
| Done | Live in production |

---

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

---

## Repo files

| File | Purpose |
|---|---|
| `scripts/work-on-ticket.sh` | Pull repo + open Claude Code session |
| `config/project-mapping.yaml` | Jira project → GitHub repo mapping |
| `claude/CLAUDE.md` | Global Claude workflow rules |
| `mcp/claude_desktop_config.json` | MCP config template for Claude Desktop |
| `install.sh` | One-time setup script |
