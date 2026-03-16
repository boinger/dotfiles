#!/usr/bin/env bash
#
# install.sh — symlink dotfiles from home/ into ~
#
# Usage:
#   ./install.sh            # create symlinks (backs up existing files)
#   ./install.sh --dry-run  # preview what would happen
#   ./install.sh --diff     # show diffs between ~/ and repo (implies --dry-run)
#   ./install.sh --help     # print this help
#

set -euo pipefail

if ! command -v python3 &> /dev/null; then
  echo "Error: python3 is required" >&2
  exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$DOTFILES_DIR/home"
DRY_RUN=false
SHOW_DIFF=false

usage() {
  sed -n '3,10s/^# \{0,1\}//p' "$0"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)  DRY_RUN=true; shift ;;
    --diff)     SHOW_DIFF=true; DRY_RUN=true; shift ;;
    -h|--help)  usage; exit 0 ;;
    *)          echo "Unknown option: $1" >&2; echo "Run '$0 --help' for usage." >&2; exit 1 ;;
  esac
done

# Resolve symlinks to real paths via python3 (macOS lacks readlink -f)
resolve_real() {
  python3 -c "import os; print(os.path.realpath('$1'))"
}

# Compute the relative path from $HOME to the repo's home/ directory.
# If ~/dotfiles is a symlink to this repo, use that shorter path to match
# existing symlink targets (e.g. dotfiles/home/.bashrc).
if [[ -L "$HOME/dotfiles" ]] && [[ "$(resolve_real "$HOME/dotfiles")" == "$DOTFILES_DIR" ]]; then
  RELATIVE_HOME="dotfiles/home"
else
  RELATIVE_HOME="$(python3 -c "import os; print(os.path.relpath('$HOME_DIR', '$HOME'))")"
fi

# Build array of dotfile sources once
DOTFILE_SOURCES=()
for src in "$HOME_DIR"/.*; do
  filename="$(basename "$src")"
  [[ "$filename" == "." || "$filename" == ".." ]] && continue
  DOTFILE_SOURCES+=("$src")
done

# Check whether $target is already a symlink pointing at the correct destination
is_correctly_linked() {
  local target="$1" link_target="$2" src="$3"
  [[ -L "$target" ]] || return 1
  local existing
  existing="$(readlink "$target")"
  [[ "$existing" == "$link_target" ]] && return 0
  [[ "$(resolve_real "$target")" == "$(resolve_real "$src")" ]] && return 0
  return 1
}

# Detect color support for diff
DIFF_CMD=(diff)
if diff --color=auto /dev/null /dev/null 2>/dev/null; then
  DIFF_CMD=(diff --color=auto)
fi

diff_dotfiles() {
  local rc=0 linked=0

  for src in "${DOTFILE_SOURCES[@]}"; do
    local filename target link_target drc
    filename="$(basename "$src")"
    target="$HOME/$filename"
    link_target="$RELATIVE_HOME/$filename"

    # Already correct symlink → count for summary
    if is_correctly_linked "$target" "$link_target" "$src"; then
      (( linked++ ))
      continue
    fi

    # Dangling symlink
    if [[ -L "$target" && ! -e "$target" ]]; then
      echo "[broken]  $target -> $(readlink "$target")"
      drc=1; (( drc > rc )) && rc=$drc
      continue
    fi

    # Symlink pointing elsewhere
    if [[ -L "$target" ]]; then
      echo "[relink]  $target (currently -> $(readlink "$target"))"
      local resolved
      resolved="$(resolve_real "$target")"
      if [[ ! -e "$resolved" ]]; then
        drc=1; (( drc > rc )) && rc=$drc
      elif [[ -d "$resolved" && ! -d "$src" ]] || [[ ! -d "$resolved" && -d "$src" ]]; then
        echo "[mismatch] $target: type differs ($([ -d "$resolved" ] && echo dir || echo file) vs $([ -d "$src" ] && echo dir || echo file))"
        drc=1; (( drc > rc )) && rc=$drc
      else
        echo "         content diff of resolved target (installer will replace the symlink):"
        drc=0; "${DIFF_CMD[@]}" -u "$resolved" "$src" || drc=$?
        (( drc > rc )) && rc=$drc
      fi
      continue
    fi

    # Target doesn't exist → new file
    if [[ ! -e "$target" ]]; then
      echo "[new]     $filename"
      continue
    fi

    # Regular file or directory exists
    if [[ -d "$target" ]]; then
      drc=0; "${DIFF_CMD[@]}" -rq "$target" "$src" || drc=$?
    else
      drc=0; "${DIFF_CMD[@]}" -u "$target" "$src" || drc=$?
    fi

    if [[ "$drc" -eq 0 ]]; then
      : # no differences — skip silently
    elif [[ "$drc" -eq 2 ]]; then
      echo "warning: diff error for $filename" >&2
    fi
    (( drc > rc )) && rc=$drc
  done

  if [[ "$linked" -gt 0 ]]; then
    echo "$linked file(s) already correctly linked — no differences"
  fi

  return "$rc"
}

# --diff mode: show differences and exit
if [[ "$SHOW_DIFF" == true ]]; then
  diff_dotfiles
  exit $?
fi

# --dry-run banner
if [[ "$DRY_RUN" == true ]]; then
  echo "=== DRY RUN (no changes will be made) ==="
  echo
fi

# Install: symlink each dotfile
for src in "${DOTFILE_SOURCES[@]}"; do
  filename="$(basename "$src")"
  target="$HOME/$filename"
  link_target="$RELATIVE_HOME/$filename"

  # Already the correct symlink → skip
  if is_correctly_linked "$target" "$link_target" "$src"; then
    echo "skip     $target (already linked)"
    continue
  fi

  # Target exists (file, dir, or wrong symlink) → backup then link
  if [[ -e "$target" || -L "$target" ]]; then
    backup="${target}.dotfiles-bak.$(date +%Y%m%d-%H%M%S)"
    echo "backup   $target → $backup"
    if [[ "$DRY_RUN" == false ]]; then
      mv "$target" "$backup"
    fi
  fi

  # Create symlink
  echo "link     $target → $link_target"
  if [[ "$DRY_RUN" == false ]]; then
    ln -s "$link_target" "$target"
  fi
done

echo
if [[ "$DRY_RUN" == true ]]; then
  echo "Done (dry run). Re-run without --dry-run to apply."
else
  echo "Done. All dotfiles linked."
fi
