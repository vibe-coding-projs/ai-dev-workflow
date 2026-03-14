#!/bin/bash
# install.sh
# Run once on a new machine to set up the AI dev workflow.
# Usage: ./install.sh

set -e

echo "=== AI Dev Workflow Setup ==="
echo ""

# 1. Make scripts executable
chmod +x scripts/work-on-ticket.sh
echo "✓ Scripts are executable"

# 2. Copy MCP config to Claude Desktop
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/config.json"

mkdir -p "$CLAUDE_CONFIG_DIR"

if [ -f "$CLAUDE_CONFIG_FILE" ]; then
  echo "⚠ Claude Desktop config already exists at $CLAUDE_CONFIG_FILE"
  echo "  Merge mcp/claude_desktop_config.json manually."
else
  cp mcp/claude_desktop_config.json "$CLAUDE_CONFIG_FILE"
  echo "✓ MCP config copied to Claude Desktop"
fi

# 3. Remind user to fill in secrets
echo ""
echo "=== Next steps ==="
echo "1. Fill in your tokens in: $CLAUDE_CONFIG_FILE"
echo "   - GITHUB_PERSONAL_ACCESS_TOKEN"
echo "   - JIRA_HOST, JIRA_EMAIL, JIRA_API_TOKEN"
echo ""
echo "2. Update config/project-mapping.yaml with your Jira projects"
echo ""
echo "3. Restart Claude Desktop"
echo ""
echo "4. Run a ticket:"
echo "   ./scripts/work-on-ticket.sh DMP-42"
echo ""
echo "Done!"
