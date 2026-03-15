# dotfiles

Personal dotfiles, managed via symlinks from `home/` into `~`.

## Install

```bash
git clone git@github.com:boinger/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run  # preview what would happen
./install.sh            # create symlinks
```

The installer is idempotent — correct symlinks are skipped, existing files are backed up to `<file>.dotfiles-bak.<timestamp>` before overwriting. Requires `python3`.

## What's included

### Shell

| File | Purpose |
|------|---------|
| `.bashrc` | Main shell config: PATH, aliases, prompt, OS detection (Darwin/Linux) |
| `.bash_profile` | Login shell setup, sources `.bashrc` with loop prevention |
| `.bash_functions` | Shared shell functions sourced by `.bashrc` |
| `.bash_logout` | Cleanup on shell exit |
| `.inputrc` | Readline: case-insensitive completion, history-search on Up/Down, no bell |
| `.profile` | Cargo/Rust PATH for non-bash contexts |
| `.zshenv` | Cargo/Rust PATH for non-bash contexts |
| `.hushlogin` | Suppresses "Last login" banner |

### Editor

| File | Purpose |
|------|---------|
| `.vimrc` | Vim config: 2-space soft tabs, syntax highlighting, filetype plugins |
| `.ideavimrc` | IdeaVim (JetBrains) vim emulation settings |
| `.editorconfig` | Editor-agnostic indent/whitespace rules (2-space default, overrides for Make/Go/Python/C#) |

### Git

| File | Purpose |
|------|---------|
| `.gitconfig` | Identity, aliases, LFS, pull rebase, SSH URL rewriting |
| `.gitignore_global` | Global ignore patterns (OS files, editor temps, credentials) |
| `.gitattributes` | Binary detection, language-aware diffs (markdown, ruby, python) |
| `.gitmessage` | Commit message template with imperative-mood reminders |

### Tools

| File | Purpose |
|------|---------|
| `.tmux.conf` | tmux: mouse on, vim-style pane nav, SSH agent persistence |
| `.curlrc` | curl: follow redirects, connection/operation timeouts |
| `.wgetrc` | wget: retries, server timestamps, no-parent |
| `.nethackrc` | NetHack: menucolors, autopickup, fruit config |

### Brewfile

`Brewfile` (repo root) captures Homebrew packages via `brew bundle dump`. Restore on a new machine with `brew bundle install`.

## Shell architecture

Bash-only. The sourcing chain uses mutual recursion with loop prevention:

- `.bash_profile` sets `bash_profile_processed=1`, then sources `.bashrc` if not already processed
- `.bashrc` sets `bashrc_processed=1`, then sources `.bash_profile` if not already processed

This ensures both files run exactly once regardless of which one the shell invokes first. OS-specific behavior is handled via `UNAME=$(uname)` conditionals throughout.
