# AGENTS.md

## Cursor Cloud specific instructions

This repository is **`deyloop`'s personal dotfiles** — config files plus a suite of
bash utility scripts intended to replicate a personal Arch Linux desktop. There is
**no package manager, lockfile, test suite, or build system**. The "application" is
the collection of scripts in `scripts/` and the config files (`tmux/`, `vim/`,
`git/`, `alacritty/`, `xmonad/`, `xmobar/`, `picom/`, `rofi/`, `bash/`).

### What can and cannot run in the cloud VM
- **Runnable here:** the bash scripts in `scripts/` (e.g. `hello`, `isosec`,
  `hline`, `aln`, `cmt`, `fmttable`) and the text-based configs (`tmux`, `vim`,
  `git`). These are the core, testable functionality.
- **Cannot fully run here:** the desktop stack — `xmonad` (Haskell), `xmobar`,
  `picom`, `rofi`, `alacritty`, `dex`, `feh`. These need a running X server plus
  Arch packages that are not installed in the headless cloud VM, so the window
  manager itself cannot be launched/recompiled here.

### Lint / validate / run
- **Lint:** `shellcheck` is the linter for the bash scripts (e.g.
  `shellcheck scripts/*`). Note the checked-in scripts already emit some
  pre-existing findings (e.g. `SC2071` in `scripts/aln`) — these are not
  regressions, do not "fix" them unless that is the task.
- **Validate tmux config:** `tmux -L test -f tmux/tmux.conf start-server \; show-options -g \; kill-server`
  (the config `source`s `~/.config/tmux/*.conf`, so symlink `tmux/` to
  `~/.config/tmux` first, or point tmux directly at the files).
- **Validate vimrc headlessly:** `vim -u vim/vimrc -N -es -c 'qa!'`.
- **Run a script:** just execute it, e.g. `scripts/hello`, or pipe input like
  `printf '| a | b |\n| - | - |\n| 1 | 2 |\n' | scripts/fmttable`.

### Gotchas
- The `*/setup` scripts (`bash/setup`, `git/setup`, `tmux/setup`, `vim/setup`,
  `scripts/setup`) install by **symlinking configs into `$HOME`**. In particular
  `bash/setup` overwrites `~/.bashrc` / `~/.profile` with deyloop's versions
  (which `source ~/.local/bin/scripts/*` and expect the desktop tools). Do **not**
  run `bash/setup` casually in the shared VM — it can disrupt the current shell.
- The git submodules in `.gitmodules` (`fonts`, `themes/*`, `icons/*`) use
  `git@github.com:` SSH URLs and are only fonts/themes/icons for the desktop; they
  are not needed to run or test the scripts and will fail to fetch without SSH keys.
