# AI Dev Workflow

Config and scripts for a Jira → Claude Code → GitHub → Render preview workflow.

---

## For Product Managers

### How it works

You write a Jira ticket. Claude Code implements it, opens a PR, and gives you a preview link to review — all automatically. You never need to touch code or GitHub.

```
You write Jira ticket
       ↓
Technical Product / Dev runs: ./scripts/work-on-ticket.sh DMP-1
       ↓
Claude reads your ticket, builds the feature, opens a PR
       ↓
You get a preview URL posted as a Jira comment
       ↓
You review the preview in your browser
       ↓
You add an approval comment to the Jira ticket
       ↓
Dev team reviews the code and merges → goes live
```

---

### Step 1 — Write a good Jira ticket

The quality of Claude's output depends on the quality of your ticket. Use this template:

```
## What
[One sentence describing what needs to change]

## Why
[The user problem or business reason]

## Acceptance Criteria
- [ ] [Specific thing that must be true when done]
- [ ] [Another specific thing]

## Design / references
[Link to Figma, screenshot, or example if relevant]
```

**Tips:**
- Be specific about what you want to see, not how to build it
- Include screenshots or examples where possible
- Acceptance criteria should be things you can visually verify in the preview

---

### Step 2 — Wait for the preview

Once a developer kicks off the session, Claude will post updates directly to your Jira ticket as comments, including:
- What branch was created
- What changes were made and why
- A **preview URL** to review the feature live

The preview URL looks like: `https://dmp-1-feature-name.onrender.com`

> Note: The preview environment may take 1-2 minutes to spin up after the comment is posted.

---

### Step 3 — Review the preview

Open the preview URL in your browser and check against your acceptance criteria.

- If it looks good → add a comment on the Jira ticket saying **"Approved"**
- If changes are needed → add a comment describing what's wrong. The developer will ask Claude to iterate.

---

### Step 4 — Done

Once you've commented "Approved", the dev team reviews the code and merges it. The feature goes live automatically on production.

You'll see the ticket move to **Done** when it's live.

---

### One-time setup (ask your developer to do this)

PMs don't need to install anything. Ask your developer to run:

```bash
git clone https://github.com/vibe-coding-projs/ai-dev-workflow.git
cd ai-dev-workflow
./install.sh
```

---

## For Technical Product / Developers

This is the person who runs Claude Code sessions to implement Jira tickets. They don't need to write code themselves — Claude does the implementation — but they need a working local environment.

### Prerequisites

Install the following before running setup:

| Tool | Install | Purpose |
|---|---|---|
| **macOS** | — | Scripts are Mac-only (zsh) |
| **Git** | Pre-installed on Mac or [git-scm.com](https://git-scm.com) | Clone and push repos |
| **Node.js + npm** | [nodejs.org](https://nodejs.org) (LTS version) | Run GitHub MCP server |
| **Claude Code CLI** | `npm install -g @anthropic-ai/claude-code` | AI coding sessions |
| **Claude Pro account** | [claude.ai](https://claude.ai) | Required to use Claude Code |
| **GitHub account** | [github.com](https://github.com) | Access to org repos |
| **Jira account** | Your org's Atlassian workspace | Access to tickets |

Verify everything is installed:

```bash
git --version       # should print git version
node --version      # should print v18 or higher
npm --version       # should print 9 or higher
claude --version    # should print claude version
```

---

### One-time setup

```bash
git clone https://github.com/vibe-coding-projs/ai-dev-workflow.git
cd ai-dev-workflow
./install.sh
```

The install script will:
1. Install `uv` (Python tool runner, needed for Jira MCP)
2. Prompt you for your tokens (GitHub + Jira)
3. Configure MCPs for both **Claude Desktop** and **Claude Code CLI** (user-scoped, applies across all repos)
4. Copy the global `CLAUDE.md` to `~/.claude/CLAUDE.md` so Claude follows the workflow rules in every session

You'll need the following tokens ready:

| Token | Where to get it |
|---|---|
| GitHub Personal Access Token | [GitHub → Settings → Developer Settings → Personal Access Tokens](https://github.com/settings/tokens) — enable `repo` scope |
| Jira URL | Your org's Atlassian URL e.g. `https://your-org.atlassian.net` |
| Jira Email | The email you use to log into Jira |
| Jira API Token | [Atlassian → Account Settings → Security → API Tokens](https://id.atlassian.com/manage-profile/security/api-tokens) |

> Note: Claude Desktop uses two separate config files:
> - `config.json` — internal preferences (do not edit)
> - `claude_desktop_config.json` — MCP servers (this is what the install script writes)

---

### Working on a ticket

```bash
cd ai-dev-workflow
./scripts/work-on-ticket.sh DMP-1
```

Claude will automatically:
- Read the Jira ticket
- Set ticket status to **In Progress**
- Create a branch, write code, open a PR
- Post a Jira comment per meaningful change
- Set ticket status to **In Review** with PR link + preview URL
- Output a handoff block for team continuity

---

### Continuing a session someone else started

Copy the handoff block from the Jira ticket comment and paste it into a new Claude Code session, then say:

```
continue work on DMP-1
```

---

### Adding a new project

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

## Jira workflow statuses

| Status | Set by | Meaning |
|---|---|---|
| To Do | PM | Ticket is ready to be worked on |
| In Progress | Claude | Development has started |
| In Review | Claude | PR is open, preview is ready for PM review |
| In Review + "Approved" comment | PM | PM has reviewed preview and signed off |
| Done | Dev | Merged to main, live in production |

---

## Files

| File | Purpose |
|---|---|
| `scripts/work-on-ticket.sh` | Pull repo + open Claude Code session |
| `config/project-mapping.yaml` | Jira project → GitHub repo mapping |
| `claude/CLAUDE.md` | Global Claude Code workflow rules (copied to `~/.claude/CLAUDE.md`) |
| `mcp/claude_desktop_config.json` | MCP config template for Claude Desktop |
| `install.sh` | One-time setup script |
