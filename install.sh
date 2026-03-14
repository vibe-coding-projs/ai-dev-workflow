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
echo ""

# 2. Install uv/uvx if missing (required for mcp-atlassian)
if ! command -v uvx &>/dev/null && ! [ -f "$HOME/.local/bin/uvx" ]; then
  echo "Installing uv (required for Jira MCP)..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
  echo "✓ uv installed"
else
  echo "✓ uv already installed"
fi
UVX_PATH="$HOME/.local/bin/uvx"
echo ""

# 3. Collect tokens interactively
echo "=== Enter your credentials ==="
echo "(These will be saved to your Claude Desktop and Claude Code MCP config)"
echo ""

read -p "GitHub Personal Access Token: " GITHUB_TOKEN
read -p "Jira URL (e.g. https://your-org.atlassian.net): " JIRA_URL
read -p "Jira Email: " JIRA_EMAIL
read -p "Jira API Token: " JIRA_API_TOKEN

echo ""

# 4. Write MCP config for Claude Desktop
# Note: MCP servers go in claude_desktop_config.json, NOT config.json
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
MCP_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

mkdir -p "$CLAUDE_CONFIG_DIR"

cat > "$MCP_CONFIG_FILE" <<EOF
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_TOKEN"
      }
    },
    "mcp-atlassian": {
      "command": "$UVX_PATH",
      "args": ["mcp-atlassian"],
      "env": {
        "JIRA_URL": "$JIRA_URL",
        "JIRA_USERNAME": "$JIRA_EMAIL",
        "JIRA_API_TOKEN": "$JIRA_API_TOKEN"
      }
    }
  }
}
EOF

echo "✓ Claude Desktop MCP config written to: $MCP_CONFIG_FILE"

# 5. Add MCPs to Claude Code CLI (user scope — applies across all repos)
echo "Configuring Claude Code CLI MCPs..."

claude mcp add mcp-atlassian \
  --scope user \
  --env JIRA_URL="$JIRA_URL" \
  --env JIRA_USERNAME="$JIRA_EMAIL" \
  --env JIRA_API_TOKEN="$JIRA_API_TOKEN" \
  -- "$UVX_PATH" mcp-atlassian

claude mcp add github \
  --scope user \
  --env GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" \
  -- npx -y @modelcontextprotocol/server-github

echo "✓ Claude Code CLI MCPs configured"

# 6. Copy global CLAUDE.md to ~/.claude/
mkdir -p "$HOME/.claude"
cp claude/CLAUDE.md "$HOME/.claude/CLAUDE.md"
echo "✓ Global CLAUDE.md copied to ~/.claude/CLAUDE.md"

echo ""

# 7. Done
echo "=== Next steps ==="
echo "1. Update config/project-mapping.yaml with your Jira projects"
echo "2. Restart Claude Desktop"
echo "3. Run a ticket:"
echo "   ./scripts/work-on-ticket.sh DMP-1"
echo ""
echo "Done!"
