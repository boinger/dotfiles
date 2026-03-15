#!/usr/bin/env bash
#
# install.sh — symlink dotfiles from home/ into ~
#
# Usage:
#   ./install.sh            # create symlinks (backs up existing files)
#   ./install.sh --dry-run  # preview what would happen
#

set -euo pipefail

if ! command -v python3 &> /dev/null; then
  echo "Error: python3 is required" >&2
  exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$DOTFILES_DIR/home"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "=== DRY RUN (no changes will be made) ==="
  echo
fi

# Compute the relative path from $HOME to the repo's home/ directory.
# If ~/dotfiles is a symlink to this repo, use that shorter path to match
# existing symlink targets (e.g. dotfiles/home/.bashrc).
resolve_real() {
  python3 -c "import os; print(os.path.realpath('$1'))"
}

if [[ -L "$HOME/dotfiles" ]] && [[ "$(resolve_real "$HOME/dotfiles")" == "$DOTFILES_DIR" ]]; then
  RELATIVE_HOME="dotfiles/home"
else
  RELATIVE_HOME="$(python3 -c "import os; print(os.path.relpath('$HOME_DIR', '$HOME'))")"
fi

for src in "$HOME_DIR"/.*; do
  filename="$(basename "$src")"

  # Skip . and ..
  [[ "$filename" == "." || "$filename" == ".." ]] && continue

  target="$HOME/$filename"
  link_target="$RELATIVE_HOME/$filename"

  # 1) Already the correct symlink → skip
  #    Compare both the literal link text and the resolved real path,
  #    so old-style and new-style relative links are both recognized.
  if [[ -L "$target" ]]; then
    existing="$(readlink "$target")"
    if [[ "$existing" == "$link_target" ]]; then
      echo "skip     $target (already linked)"
      continue
    fi
    if [[ "$(resolve_real "$target")" == "$(resolve_real "$src")" ]]; then
      echo "skip     $target (already linked)"
      continue
    fi
  fi

  # 2) Target exists (file, dir, or wrong symlink) → backup then link
  if [[ -e "$target" || -L "$target" ]]; then
    backup="${target}.dotfiles-bak.$(date +%Y%m%d-%H%M%S)"
    echo "backup   $target → $backup"
    if [[ "$DRY_RUN" == false ]]; then
      mv "$target" "$backup"
    fi
  fi

  # 3) Create symlink
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
