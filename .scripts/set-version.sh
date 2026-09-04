#!/usr/bin/env bash
# Writes the given semantic version into the VERSION_* constants of both mod
# variants (Vanilla and War of the Chosen).
#
# Usage: set-version.sh <major.minor.patch>
set -euo pipefail

VERSION="${1:-}"
if [[ ! "$VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "Usage: $0 <major.minor.patch>" >&2
    exit 1
fi
MAJOR="${BASH_REMATCH[1]}"
MINOR="${BASH_REMATCH[2]}"
PATCH="${BASH_REMATCH[3]}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETTINGS_FILES=(
    "$REPO_ROOT/BetterCostStrings/Src/BetterCostStrings/Classes/BetterCostStrings_Settings.uc"
    "$REPO_ROOT/BetterCostStringsWotC/Src/BetterCostStringsWotC/Classes/BetterCostStrings_Settings.uc"
)

current_version() {
    local file="$1"
    local major minor patch
    major="$(grep -oP '(?<=^const VERSION_MAJOR = )[0-9]+' "$file")"
    minor="$(grep -oP '(?<=^const VERSION_MINOR = )[0-9]+' "$file")"
    patch="$(grep -oP '(?<=^const VERSION_PATCH = )[0-9]+' "$file")"
    echo "$major.$minor.$patch"
}

REFERENCE_VERSION="$(current_version "${SETTINGS_FILES[0]}")"
for SETTINGS_FILE in "${SETTINGS_FILES[@]:1}"; do
    FILE_VERSION="$(current_version "$SETTINGS_FILE")"
    if [[ "$FILE_VERSION" != "$REFERENCE_VERSION" ]]; then
        echo "Version mismatch: ${SETTINGS_FILES[0]} is at $REFERENCE_VERSION but $SETTINGS_FILE is at $FILE_VERSION" >&2
        exit 1
    fi
done

for SETTINGS_FILE in "${SETTINGS_FILES[@]}"; do
    sed -i \
        -e "s/^const VERSION_MAJOR = [0-9]\+;\r\?$/const VERSION_MAJOR = $MAJOR;/" \
        -e "s/^const VERSION_MINOR = [0-9]\+;\r\?$/const VERSION_MINOR = $MINOR;/" \
        -e "s/^const VERSION_PATCH = [0-9]\+;\r\?$/const VERSION_PATCH = $PATCH;/" \
        "$SETTINGS_FILE"

    for CONSTANT in "VERSION_MAJOR = $MAJOR" "VERSION_MINOR = $MINOR" "VERSION_PATCH = $PATCH"; do
        if ! grep -q "^const $CONSTANT;\r\?$" "$SETTINGS_FILE"; then
            echo "Failed to set $CONSTANT in $SETTINGS_FILE" >&2
            exit 1
        fi
    done
done

echo "Set mod version to $VERSION"
