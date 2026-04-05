# dotfiles

Linux dotfiles for quickly bootstrapping a usable coding environment.

## Collections

- bootstrap installer (`install.sh`)
- [git](https://git-scm.org) global and workspace-scoped configuration
- shell/tmux configuration
- [neovim](https://neovim.io) configuration

## Setup

```sh
sh install.sh
```

`install.sh` targets Linux distributions that use **apt-get** or **dnf**. It installs baseline tools (`curl`, `git`, `neovim`, `tmux`, `ripgrep`, `fzf`) and wires this repository into your home config:

- `git/` -> `${XDG_CONFIG_HOME:-$HOME/.config}/git`
- `nvim/` -> `${XDG_CONFIG_HOME:-$HOME/.config}/nvim`
- `tmux.conf` -> `~/.tmux.conf`
- `gitconfig.template` -> `~/.gitconfig` (only when missing by default)

### Optional environment variables

- `OVERWRITE_GITCONFIG=1`: overwrite `~/.gitconfig`
- `INSTALL_SSH_KEYS_FROM_GITHUB=1`: write GitHub public keys to `authorized_keys`
- `GITHUB_KEYS_USER=<github-username>`: source account for keys download
