# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for Jeff Vier (`boinger/dotfiles`). All managed dotfiles live in the `home/` directory — they are not at the repo root.

## Install

`install.sh` symlinks all dotfiles from `home/` into `~`:

```bash
./install.sh            # create symlinks
./install.sh --dry-run  # preview what would happen
./install.sh --diff     # show diffs between ~/ and repo (implies --dry-run)
./install.sh --help     # print usage
```

- **Idempotent**: correct symlinks are skipped on re-run
- **Safe**: existing files are backed up to `<file>.dotfiles-bak.<timestamp>` before overwriting
- **Relative symlinks**: uses `dotfiles/home/<file>` paths (via `~/dotfiles` symlink to repo)
- **`--diff` exit codes**: `0` = no differences, `1` = differences found, `2` = error (follows `diff` convention)
- **Requires**: `python3` (used for path resolution)

## No Build/Test/Lint

This is a pure configuration repository. There are no build commands, test suites, or linters.

## Shell Configuration Architecture

Bash-only (no zsh). `.zshenv` and `.profile` exist solely to set up cargo/Rust PATH for non-bash contexts. The sourcing chain has **mutual recursion with loop prevention**:

- `.bash_profile` sets `bash_profile_processed=1`, then sources `.bashrc` only if `bashrc_processed` is not set
- `.bashrc` sets `bashrc_processed=1`, then sources `.bash_profile` only if `bash_profile_processed` is not set
- `.bashrc` also sources `.bash_functions`

This ensures both files run exactly once regardless of which one the shell invokes first.

**OS detection** uses `UNAME=$(uname)` and conditionals throughout (Darwin vs Linux paths, Perl config, Java home, PS1 colors, etc.).

## Additional Dotfiles

- **`.inputrc`** — readline config: case-insensitive completion, history-search on Up/Down, no bell
- **`.editorconfig`** — editor-agnostic indent/whitespace rules matching `.vimrc` conventions
- **`.tmux.conf`** — tmux config: mouse on, vim-style pane nav, SSH agent persistence via `update-environment`
- **`.curlrc`** / **`.wgetrc`** — sensible defaults for curl (follow redirects, timeouts) and wget (retries, timestamps)
- **`.gitattributes`** — global git attributes for binary detection and language-aware diffs (wired via `core.attributesFile`)
- **`.gitmessage`** — commit message template with reminders (wired via `commit.template`)
- **`.hushlogin`** — empty file; suppresses "Last login" banner on macOS/Linux
- **`Brewfile`** (repo root, not `home/`) — Homebrew package manifest dumped from `brew bundle dump`

## Conventions

- **Conditional PATH additions**: always check if a directory exists before appending (`[ -d "/path" ] && export PATH=$PATH:/path`)
- **Conditional tool aliases**: check if a binary exists before aliasing (`command -v vim > /dev/null && alias vi='...'`)
- **Vim style**: 2-space soft tabs (`expandtab`, `shiftwidth=2`, `softtabstop=2`). Makefiles override to hard tabs/8-width.
- **Git identity**: jeff@jeffvier.com / jv
- **Commit messages**: describe what changed and why; no AI references
