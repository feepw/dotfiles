#!/usr/bin/env sh
set -eu

PACKAGES="curl git neovim tmux ripgrep fzf"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
INSTALL_SSH_KEYS_FROM_GITHUB="${INSTALL_SSH_KEYS_FROM_GITHUB:-0}"
GITHUB_KEYS_USER="${GITHUB_KEYS_USER:-feepw}"
OVERWRITE_GITCONFIG="${OVERWRITE_GITCONFIG:-0}"

log() {
  printf '%s\n' "$*"
}

error() {
  printf 'Error: %s\n' "$*" >&2
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    error "required command not found: $1"
    exit 1
  fi
}

detect_package_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    printf 'apt-get\n'
    return
  fi
  if command -v dnf >/dev/null 2>&1; then
    printf 'dnf\n'
    return
  fi
  error "unsupported package manager. install.sh supports apt-get and dnf."
  exit 1
}

setup_sudo() {
  if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
    return
  fi
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
    return
  fi
  error "sudo is required when running as non-root user."
  exit 1
}

install_packages_apt() {
  log "Installing packages with apt-get: $PACKAGES"
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get update -y
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y --no-install-recommends $PACKAGES
}

install_packages_dnf() {
  log "Installing packages with dnf: $PACKAGES"
  $SUDO dnf -y install $PACKAGES
}

link_or_copy() {
  src="$1"
  dst="$2"
  mode="$3"

  mkdir -p "$(dirname "$dst")"
  if [ "$mode" = "symlink" ]; then
    ln -sfn "$src" "$dst"
    return
  fi
  cp -f "$src" "$dst"
}

configure_dotfiles() {
  script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

  mkdir -p "$XDG_CONFIG_HOME"
  link_or_copy "$script_dir/git" "$XDG_CONFIG_HOME/git" "symlink"
  link_or_copy "$script_dir/nvim" "$XDG_CONFIG_HOME/nvim" "symlink"
  link_or_copy "$script_dir/tmux.conf" "$HOME/.tmux.conf" "symlink"

  if [ "$OVERWRITE_GITCONFIG" = "1" ] || [ ! -f "$HOME/.gitconfig" ]; then
    link_or_copy "$script_dir/gitconfig.template" "$HOME/.gitconfig" "copy"
  else
    log "Skip ~/.gitconfig (set OVERWRITE_GITCONFIG=1 to replace it)"
  fi

}

configure_ssh_keys() {
  if [ "$INSTALL_SSH_KEYS_FROM_GITHUB" != "1" ]; then
    return
  fi

  require_command curl
  ssh_dir="${SSH_DIR:-$HOME/.ssh}"
  mkdir -p "$ssh_dir"
  chmod 700 "$ssh_dir"

  curl -fsSL -o "$ssh_dir/authorized_keys" "https://github.com/${GITHUB_KEYS_USER}.keys"
  chmod 600 "$ssh_dir/authorized_keys"
  log "Installed authorized_keys from https://github.com/${GITHUB_KEYS_USER}.keys"
}

main() {
  setup_sudo
  package_manager="$(detect_package_manager)"

  case "$package_manager" in
    apt-get) install_packages_apt ;;
    dnf) install_packages_dnf ;;
    *)
      error "unsupported package manager: $package_manager"
      exit 1
      ;;
  esac

  configure_dotfiles
  configure_ssh_keys

  log "Done. Open Neovim with: nvim"
}

main "$@"
