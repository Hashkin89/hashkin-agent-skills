#!/usr/bin/env bash
# Sync ~/.agents/skills vers ce repo et push sur GitHub.
# Usage: ./scripts/sync.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$HOME/.agents/skills/"
DEST="$REPO_DIR/skills/"

echo "Sync $SOURCE → $DEST"
rsync -a --delete --exclude='.DS_Store' "$SOURCE" "$DEST"

cd "$REPO_DIR"

if git diff --quiet && git diff --cached --quiet && [ -z "$(git status --porcelain)" ]; then
  echo "Rien à synchroniser — le backup est déjà à jour."
  exit 0
fi

git add -A
git commit -m "Sync skills — $(date '+%Y-%m-%d %H:%M')"
git push

echo "✓ Backup mis à jour et poussé sur GitHub."
