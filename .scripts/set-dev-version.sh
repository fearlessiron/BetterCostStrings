#!/usr/bin/env bash
# Bumps the patch version after a release, commits the change and pushes it.
#
# Usage: set-dev-version.sh <released major.minor.patch> <branch>
set -euo pipefail

RELEASED_VERSION="${1:-}"
BRANCH="${2:-}"
if [[ ! "$RELEASED_VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]] || [[ -z "$BRANCH" ]]; then
    echo "Usage: $0 <released major.minor.patch> <branch>" >&2
    exit 1
fi
DEV_VERSION="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.$((BASH_REMATCH[3] + 1))"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SETTINGS_FILES=(
    "BetterCostStrings/Src/BetterCostStrings/Classes/BetterCostStrings_Settings.uc"
    "BetterCostStringsWotC/Src/BetterCostStringsWotC/Classes/BetterCostStrings_Settings.uc"
)

bash "$SCRIPT_DIR/set-version.sh" "$DEV_VERSION"

cd "$REPO_ROOT"
git add "${SETTINGS_FILES[@]}"
git commit -m "build: set new development version"
git push origin "HEAD:refs/heads/$BRANCH"

echo "Development version $DEV_VERSION pushed to $BRANCH"
