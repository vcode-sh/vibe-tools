#!/usr/bin/env bash
set -euo pipefail

# import-skills.sh — Sync skill plugins from vibe-skills/.dist to vibe-tools/skills/
# Usage: ./scripts/import-skills.sh [source-path] [--clean] [--dry-run]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MARKETPLACE="$REPO_ROOT/.claude-plugin/marketplace.json"
SKILLS_DIR="$REPO_ROOT/skills"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Defaults
SOURCE_PATH=""
CLEAN=false
DRY_RUN=false

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --clean) CLEAN=true ;;
    --dry-run) DRY_RUN=true ;;
    -*) echo -e "${RED}Unknown flag: $arg${NC}" >&2; exit 1 ;;
    *) SOURCE_PATH="$arg" ;;
  esac
done

# Default source path
if [[ -z "$SOURCE_PATH" ]]; then
  SOURCE_PATH="$REPO_ROOT/../vibe-skills/.dist"
fi

# Resolve to absolute path
SOURCE_PATH="$(cd "$SOURCE_PATH" 2>/dev/null && pwd)" || {
  echo -e "${RED}Error: Source path does not exist: $SOURCE_PATH${NC}" >&2
  exit 1
}

# Verify source has plugin dirs
plugin_dirs=("$SOURCE_PATH"/*-plugin/)
if [[ ! -d "${plugin_dirs[0]}" ]]; then
  echo -e "${RED}Error: No *-plugin/ directories found in $SOURCE_PATH${NC}" >&2
  exit 1
fi

# Verify jq is available
if ! command -v jq &>/dev/null; then
  echo -e "${RED}Error: jq is required but not installed. Install with: brew install jq${NC}" >&2
  exit 1
fi

# Verify marketplace.json exists
if [[ ! -f "$MARKETPLACE" ]]; then
  echo -e "${RED}Error: marketplace.json not found at $MARKETPLACE${NC}" >&2
  exit 1
fi

if $DRY_RUN; then
  echo -e "${BOLD}Dry run — no files will be modified${NC}"
  echo ""
fi

echo -e "${BOLD}Importing skills from:${NC} $SOURCE_PATH"
echo ""

# Counters
added=0
updated=0
unchanged=0
removed=0

# Process each *-plugin/ directory in source
for plugin_dir in "$SOURCE_PATH"/*-plugin/; do
  [[ -d "$plugin_dir" ]] || continue

  dir_name="$(basename "$plugin_dir")"
  plugin_json="$plugin_dir/.claude-plugin/plugin.json"

  if [[ ! -f "$plugin_json" ]]; then
    echo -e "${YELLOW}  warning: $dir_name has no .claude-plugin/plugin.json, skipping${NC}"
    continue
  fi

  # Extract metadata from plugin.json
  name="$(jq -r '.name' "$plugin_json")"
  version="$(jq -r '.version' "$plugin_json")"
  description="$(jq -r '.description' "$plugin_json")"
  keywords="$(jq -c '.keywords // []' "$plugin_json")"

  target_dir="$SKILLS_DIR/$name"

  # Check if target already exists
  if [[ -d "$target_dir" ]]; then
    existing_json="$target_dir/.claude-plugin/plugin.json"
    if [[ -f "$existing_json" ]]; then
      existing_version="$(jq -r '.version' "$existing_json")"
      if [[ "$existing_version" == "$version" ]]; then
        echo -e "${GRAY}  unchanged: $name v$version${NC}"
        ((unchanged++))
        continue
      else
        echo -e "${YELLOW}  updated: $name v$existing_version → v$version${NC}"
        if ! $DRY_RUN; then
          rm -rf "$target_dir"
        fi
        ((updated++))
      fi
    else
      echo -e "${YELLOW}  updated: $name (missing plugin.json, replacing)${NC}"
      if ! $DRY_RUN; then
        rm -rf "$target_dir"
      fi
      ((updated++))
    fi
  else
    echo -e "${GREEN}  added: $name v$version${NC}"
    ((added++))
  fi

  # Copy plugin directory to skills/
  if ! $DRY_RUN; then
    cp -R "$plugin_dir" "$target_dir"
  fi

  # Update marketplace.json
  if ! $DRY_RUN; then
    # Check if entry already exists
    existing_idx="$(jq --arg name "$name" '.plugins | to_entries[] | select(.value.name == $name) | .key' "$MARKETPLACE" 2>/dev/null || echo "")"

    if [[ -n "$existing_idx" ]]; then
      # Update existing entry
      jq --arg name "$name" \
         --arg source "./skills/$name" \
         --arg desc "$description" \
         --arg ver "$version" \
         --argjson tags "$keywords" \
         '(.plugins[] | select(.name == $name)) |= (
           .source = $source |
           .description = $desc |
           .version = $ver |
           .category = "skill-guide" |
           .tags = $tags
         )' "$MARKETPLACE" > "$MARKETPLACE.tmp" && mv "$MARKETPLACE.tmp" "$MARKETPLACE"
    else
      # Add new entry
      jq --arg name "$name" \
         --arg source "./skills/$name" \
         --arg desc "$description" \
         --arg ver "$version" \
         --argjson tags "$keywords" \
         '.plugins += [{
           name: $name,
           source: $source,
           description: $desc,
           version: $ver,
           category: "skill-guide",
           tags: $tags
         }]' "$MARKETPLACE" > "$MARKETPLACE.tmp" && mv "$MARKETPLACE.tmp" "$MARKETPLACE"
    fi
  fi
done

# --clean: remove skills that no longer exist in source
if $CLEAN; then
  echo ""
  for skill_dir in "$SKILLS_DIR"/*/; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="$(basename "$skill_dir")"
    source_plugin="$SOURCE_PATH/${skill_name}-plugin"

    if [[ ! -d "$source_plugin" ]]; then
      echo -e "${RED}  removed: $skill_name${NC}"
      if ! $DRY_RUN; then
        rm -rf "$skill_dir"
        # Remove from marketplace.json
        jq --arg name "$skill_name" '.plugins |= map(select(.name != $name))' \
          "$MARKETPLACE" > "$MARKETPLACE.tmp" && mv "$MARKETPLACE.tmp" "$MARKETPLACE"
      fi
      ((removed++))
    fi
  done
fi

# Summary
echo ""
echo -e "${BOLD}Done.${NC} added=$added updated=$updated unchanged=$unchanged removed=$removed"
