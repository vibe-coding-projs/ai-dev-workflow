#!/bin/bash
# watch-deployment.sh
# Polls Render API and sends macOS notifications on deployment status changes.
# Usage: ./scripts/watch-deployment.sh <SERVICE_NAME>
# Example: ./scripts/watch-deployment.sh dumb-music-player
#
# Run in a separate terminal alongside your Claude Code session.

set -e

SERVICE_FILTER="${1:-}"
RENDER_API_KEY="${RENDER_API_KEY:-}"
POLL_INTERVAL=10  # seconds

if [ -z "$RENDER_API_KEY" ]; then
  # Try to read from Claude Desktop config
  CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
  RENDER_API_KEY=$(python3 -c "
import json, sys
with open('$CONFIG_FILE') as f:
    config = json.load(f)
print(config.get('mcpServers', {}).get('render', {}).get('env', {}).get('RENDER_API_KEY', ''))
" 2>/dev/null)
fi

if [ -z "$RENDER_API_KEY" ]; then
  echo "Error: RENDER_API_KEY not found. Set it as an env var or run install.sh first."
  exit 1
fi

notify() {
  local TITLE="$1"
  local MSG="$2"
  osascript -e "display notification \"$MSG\" with title \"$TITLE\" sound name \"Glass\""
}

echo "Watching Render deployments${SERVICE_FILTER:+ for: $SERVICE_FILTER}..."
echo "Press Ctrl+C to stop."
echo ""

declare -A LAST_STATUS

while true; do
  SERVICES=$(curl -sf "https://api.render.com/v1/services?limit=20" \
    -H "Authorization: Bearer $RENDER_API_KEY" \
    -H "Accept: application/json" 2>/dev/null)

  if [ -z "$SERVICES" ]; then
    echo "Warning: Could not reach Render API"
    sleep $POLL_INTERVAL
    continue
  fi

  # For each service, check latest deploy status
  SERVICE_IDS=$(echo "$SERVICES" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for item in data:
    s = item.get('service', {})
    name = s.get('name', '')
    sid = s.get('id', '')
    filter_name = '$SERVICE_FILTER'
    if not filter_name or filter_name in name:
        print(f\"{sid}|{name}\")
" 2>/dev/null)

  while IFS='|' read -r SID SNAME; do
    [ -z "$SID" ] && continue

    DEPLOY=$(curl -sf "https://api.render.com/v1/services/$SID/deploys?limit=1" \
      -H "Authorization: Bearer $RENDER_API_KEY" \
      -H "Accept: application/json" 2>/dev/null)

    STATUS=$(echo "$DEPLOY" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data:
    print(data[0].get('deploy', {}).get('status', ''))
" 2>/dev/null)

    [ -z "$STATUS" ] && continue

    PREV="${LAST_STATUS[$SID]:-}"

    if [ "$STATUS" != "$PREV" ]; then
      TIMESTAMP=$(date '+%H:%M:%S')
      echo "[$TIMESTAMP] $SNAME: $PREV → $STATUS"

      case "$STATUS" in
        build_in_progress)  notify "🔨 Render: $SNAME" "Build started" ;;
        update_in_progress) notify "🚀 Render: $SNAME" "Deploying..." ;;
        live)               notify "✅ Render: $SNAME" "Deployment live!" ;;
        build_failed)       notify "❌ Render: $SNAME" "Build failed" ;;
        update_failed)      notify "❌ Render: $SNAME" "Deployment failed" ;;
        deactivated)        notify "⏸ Render: $SNAME" "Service deactivated" ;;
      esac

      LAST_STATUS[$SID]="$STATUS"
    fi
  done <<< "$SERVICE_IDS"

  sleep $POLL_INTERVAL
done
