# Global Claude Code Instructions

## Workflow rules

### When starting work on a Jira ticket
1. Read the ticket via Jira MCP
2. Update the ticket status to **In Progress**
3. Create a branch named `<PROJECT>-<id>-<short-description>` (e.g. `DMP-1-update-button-colors`)
4. Add a comment to the Jira ticket with the branch name

### During implementation
Post a Jira comment for each meaningful change, including:
- What file(s) were changed and why
- Any decision made (e.g. chose approach A over B because...)
- Any blocker or open question encountered

### When done implementing
When the user says **"push and review"** (or similar), automatically:
1. Push the branch and create a pull request on GitHub with a clear description of what was changed and why
2. Add a comment on the Jira ticket with:
   - PR link
   - Render preview URL — format: `https://<service-name>-pr-<number>.onrender.com` (may take a few minutes to spin up)
   - Summary of changes made
   - Any open questions or decisions
3. Keep the Jira ticket status as **In Progress** — it moves to **In Review** only when the PM approves

### When the PM approves the preview
When the user says **"approve"** (or similar), automatically:
1. Update the Jira ticket status to **In Review**
2. Add a comment on the Jira ticket: "Preview approved by PM. Ready for code review."

### After PR is approved (human steps — for documentation)
The following steps happen outside Claude Code:
1. **Dev team / code review agents** review the PR code on GitHub
2. **Dev** merges the PR → Render auto-deploys to production
3. Jira ticket moves to **Done**

### Session handoff block
At the end of every session, output a handoff block in this format so anyone can continue the work:

```
## Claude Session Handoff — <TICKET-ID>
**PR:** <link>
**Preview:** <render preview url>
**Branch:** <branch name>
**What was done:** <summary>
**What's pending:** <if anything>
**To continue:** paste this block into a new Claude Code session and say "continue work on <TICKET-ID>"
```
