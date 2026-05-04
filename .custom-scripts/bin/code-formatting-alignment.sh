#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------------
# code-formatting-alignment: bring files into repository to define code formatting rules,
# For fun, we named this little tool as `format-police`
# Usage: format-police sync
#
# Bash insights:
# - has custom defined functions which are invoked without parentheses, for example: `sync`
# --------------------------------------------------------------------------------------------------------

set -e # exit if anything fails

ALIAS_VERSION="1.0.0"

echo ""
echo "🚨  FormatPolice $ALIAS_VERSION — code formatting rules 🚨"
echo "───────────────────────────────────────────────────────────────"

COMMAND=$1
TARGET_DIR=".code-formatting-rules"
TARGET_STANDALONE_FILES_DESTINATION="."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORMATTING_RULES_SOURCE="$(cd "$SCRIPT_DIR/../.." && pwd)"

STANDALONE_FILES=("formatting-settings/.editorconfig")
FORMATTING_DIRS=("")

function sync_rules() {
  echo "🔍 Source: $FORMATTING_RULES_SOURCE"
  echo "📁 Target: $TARGET_DIR"

  # Safety checks
  if [ -z "$FORMATTING_RULES_SOURCE" ] || [ "$FORMATTING_RULES_SOURCE" = "/" ]; then
    echo "❌ Invalid source directory"
    exit 1
  fi

  if [ -z "$TARGET_DIR" ] || [ "$TARGET_DIR" = "/" ]; then
    echo "❌ Invalid target directory"
    exit 1
  fi

#  if [ -d "$TARGET_DIR" ]; then
#    echo "🧹 Removing existing $TARGET_DIR..."
#    rm -rf "$TARGET_DIR"
#  fi
#
#  mkdir -p "$TARGET_DIR"

  echo "✒️  Copying selected components..."
  copy_standalone_files
  echo "✅  Components synced successfully"
}

function copy_standalone_files() {
  for file in "${STANDALONE_FILES[@]}"; do
    if [ -f "$FORMATTING_RULES_SOURCE/$file" ]; then
      echo "  → Copying $file"
      cp "$FORMATTING_RULES_SOURCE/$file" "$TARGET_STANDALONE_FILES_DESTINATION"
    else
      echo "  ⚠️ Skipping missing file: $file"
    fi
  done
}

function copy_rules() {
  for dir in "${FORMATTING_DIRS[@]}"; do
    if [ -d "$FORMATTING_RULES_SOURCE/$dir" ]; then
      echo "  → Copying $dir"
      cp -r "$FORMATTING_RULES_SOURCE/$dir" "$TARGET_DIR/"
    else
      echo "  ⚠️ Skipping missing directory: $dir"
    fi
  done
}


case "$COMMAND" in
  sync)
    sync_rules
    ;;
  *)
    echo "Usage: format-police {sync}"
    exit 1
    ;;
esac

echo ""
echo "🚨  FormatPolice finished 🚨"
echo "───────────────────────────────────────────────────────────────"