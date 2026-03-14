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
Automatically do ALL of the following without being asked:
1. Create a pull request on GitHub with a clear description of what was changed and why
2. Update the Jira ticket status to **In Review**
3. Add a comment on the Jira ticket with:
   - PR link
   - Render preview URL (may take a few minutes to spin up)
   - Summary of changes made
   - Any open questions or decisions

### After PR is opened (human steps — for documentation)
The following steps happen outside Claude Code:
1. **PM** reviews the Render preview URL
2. **PM** moves Jira ticket to **PM Approved** when happy with the preview
3. **Dev team / code review agents** review the PR code on GitHub
4. **Dev** merges the PR → Render auto-deploys to production
5. Jira ticket moves to **Done**

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
