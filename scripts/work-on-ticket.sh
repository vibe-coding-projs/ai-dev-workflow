#!/bin/bash
# work-on-ticket.sh
# Usage: ./scripts/work-on-ticket.sh DMP-42
#
# Pulls the relevant repo based on Jira ticket prefix
# and opens a Claude Code session for that ticket.

set -e

TICKET=$1
MAPPING_FILE="$(dirname "$0")/../config/project-mapping.yaml"

if [ -z "$TICKET" ]; then
  echo "Usage: ./work-on-ticket.sh <TICKET-ID> (e.g. DMP-42)"
  exit 1
fi

# Extract project prefix (e.g. DMP from DMP-42)
PROJECT=$(echo "$TICKET" | sed 's/-.*//')

# Look up repo from mapping file
REPO=$(grep -A1 "^  $PROJECT:" "$MAPPING_FILE" | grep "repo:" | awk '{print $2}')
BRANCH=$(grep -A2 "^  $PROJECT:" "$MAPPING_FILE" | grep "branch:" | awk '{print $2}')
LOCAL_PATH=$(grep -A3 "^  $PROJECT:" "$MAPPING_FILE" | grep "local_path:" | awk '{print $2}')

if [ -z "$REPO" ]; then
  echo "Error: No mapping found for project '$PROJECT' in $MAPPING_FILE"
  exit 1
fi

LOCAL_PATH="${LOCAL_PATH/#\~/$HOME}"

echo "Ticket:  $TICKET"
echo "Repo:    $REPO"
echo "Branch:  $BRANCH"
echo "Path:    $LOCAL_PATH"
echo ""

# Clone or pull repo
if [ -d "$LOCAL_PATH/.git" ]; then
  echo "Pulling latest changes..."
  git -C "$LOCAL_PATH" pull origin "$BRANCH"
else
  echo "Cloning repo..."
  git clone "https://github.com/$REPO.git" "$LOCAL_PATH"
fi

# Open Claude Code session
echo ""
echo "Opening Claude Code session for $TICKET..."
cd "$LOCAL_PATH"
claude "work on jira ticket $TICKET"
