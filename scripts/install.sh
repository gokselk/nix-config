#!/usr/bin/env bash
# Install NixOS on a remote host via nixos-anywhere, pre-seeding the host
# SSH key so sops-nix decrypts on the very first activation.
#
# Usage: scripts/install.sh <host> <target>
#   host    - directory name under hosts/ (e.g. hl-node01)
#   target  - SSH target for nixos-anywhere (e.g. root@192.168.1.200)

set -euo pipefail

info() { printf '\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m \033[1m%s\033[0m\n' "$*"; }

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <host> <target>" >&2
    exit 1
fi

host="$1"
target="$2"

if [[ ! -d "hosts/$host" ]]; then
    echo "Error: Host '$host' not found" >&2
    echo "Available: $(ls -1 hosts/ | grep -v common | tr '\n' ' ')" >&2
    exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/persist/etc/ssh"

info "Generating host SSH key for $host"
ssh-keygen -t ed25519 -N "" -C "root@$host" \
    -f "$tmp/persist/etc/ssh/ssh_host_ed25519_key" >/dev/null

age_pub=$(nix run nixpkgs#ssh-to-age -- < "$tmp/persist/etc/ssh/ssh_host_ed25519_key.pub")
info "Host age key: $age_pub"

current=$(awk -v h="&$host" '$0 ~ "- " h {print $3}' .sops.yaml || true)
if [[ "$current" != "$age_pub" ]]; then
    warn "Update .sops.yaml: replace &$host with $age_pub"
    warn "Then run: just secrets-rekey"
    echo "Press enter once .sops.yaml is updated and rekeyed to continue install..."
    read -r
fi

info "Installing $host to $target"
nix run github:nix-community/nixos-anywhere -- \
    --flake ".#$host" \
    --target-host "$target" \
    --extra-files "$tmp" \
    --build-on remote

echo
echo "Done! Host key was pre-seeded; sops decrypted on first activation."
echo "Next: ssh goksel@$target  (password from secrets.yaml)"
echo "Don't forget to commit + push .sops.yaml and secrets/hosts/common/secrets.yaml"
