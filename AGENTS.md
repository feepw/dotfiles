# AGENTS.md

This is a [dotfiles](https://wiki.archlinux.org/title/Dotfiles) repository for **Linux** environment setup.

# Collections

- a bootstrap script (`install.sh`) to initialize the environment on apt-get/dnf based Linux distributions.
- [git](https://git-scm.org) global configuration.
- sh/bash/zsh configuration.
- [neovim](https://neovim.io) configuration.

# Dev Environment Tips

- shell language server.
- neovim lua runtime.

# Setup

Run:

```sh
sh install.sh
```

Optional environment variables:

- `OVERWRITE_GITCONFIG=1` to replace existing `~/.gitconfig`
- `INSTALL_SSH_KEYS_FROM_GITHUB=1` to install GitHub public keys into `authorized_keys`
- `GITHUB_KEYS_USER=<github-username>` to change the key source account
