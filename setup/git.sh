#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

resolve_script_path() {
  local path="$1"

  if command -v realpath >/dev/null 2>&1; then
    realpath "$path" 2>/dev/null && return
  fi

  if command -v readlink >/dev/null 2>&1; then
    readlink -f "$path" 2>/dev/null && return
  fi

  local dir
  dir="$(cd -P "$(dirname "$path")" && pwd)"
  printf '%s/%s\n' "$dir" "$(basename "$path")"
}

SCRIPT_PATH="$(resolve_script_path "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd -P)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd -P)"
SOURCE="$ROOT_DIR/home/.gitconfig"
DEST="$HOME/.gitconfig"

source "$ROOT_DIR/setup/lib.sh"

case "${1:-}" in
  enable)
    link_path "$SOURCE" "$DEST"
    ;;
  disable)
    unlink_path "$SOURCE" "$DEST"
    ;;
  *)
    error "Usage: bash $ROOT_DIR/home/setup/git.sh <enable|disable>"
    exit 1
    ;;
esac
