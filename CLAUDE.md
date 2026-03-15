# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for Jeff Vier (`boinger/dotfiles`). All managed dotfiles live in the `home/` directory — they are not at the repo root.

## Install

`install.sh` symlinks all dotfiles from `home/` into `~`:

```bash
./install.sh --dry-run  # preview what would happen
./install.sh            # create symlinks
```

- **Idempotent**: correct symlinks are skipped on re-run
- **Safe**: existing files are backed up to `<file>.dotfiles-bak.<timestamp>` before overwriting
- **Relative symlinks**: uses `dotfiles/home/<file>` paths (via `~/dotfiles` symlink to repo)

## No Build/Test/Lint

This is a pure configuration repository. There are no build commands, test suites, or linters.

## Shell Configuration Architecture

Bash-only (no zsh). The sourcing chain has **mutual recursion with loop prevention**:

- `.bash_profile` sets `bash_profile_processed=1`, then sources `.bashrc` only if `bashrc_processed` is not set
- `.bashrc` sets `bashrc_processed=1`, then sources `.bash_profile` only if `bash_profile_processed` is not set
- `.bashrc` also sources `.bash_functions`

This ensures both files run exactly once regardless of which one the shell invokes first.

**OS detection** uses `UNAME=$(uname)` and conditionals throughout (Darwin vs Linux paths, Perl config, Java home, PS1 colors, etc.).

## Conventions

- **Conditional PATH additions**: always check if a directory exists before appending (`[ -d "/path" ] && export PATH=$PATH:/path`)
- **Conditional tool aliases**: check if a binary exists before aliasing (`[ -e "$(which vim)" ] && alias vi='...'`)
- **Vim style**: 2-space soft tabs (`expandtab`, `shiftwidth=2`, `softtabstop=2`). Makefiles override to hard tabs/8-width.
- **Git identity**: jeff@jeffvier.com / jv
- **Commit messages**: describe what changed and why; no AI references
