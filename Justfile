# Nix Home Lab Commands
# Run `just` to see all available commands

set shell := ["bash", "-euo", "pipefail", "-c"]
set positional-arguments

# --- Variables ---
hostname := `hostname`
user := `whoami`

# Show all commands
default:
    @just --list --unsorted

# ─── Private Helpers ──────────────────────────────

[private]
_info msg:
    @echo -e "\033[1;34m==>\033[0m \033[1m{{msg}}\033[0m"

[private]
_warn msg:
    @echo -e "\033[1;33m==>\033[0m \033[1m{{msg}}\033[0m"

# ─── NixOS ────────────────────────────────────────

[group('nixos')]
[doc('Rebuild NixOS (optionally specify host)')]
rebuild host=hostname:
    @just _info "Rebuilding NixOS for {{host}}"
    nixos-rebuild switch --flake .#{{host}} --no-update-lock-file

[group('nixos')]
[doc('Test config without switching')]
test host=hostname:
    @just _info "Testing NixOS config for {{host}}"
    nixos-rebuild test --flake .#{{host}} --no-update-lock-file

[group('nixos')]
[doc('Build config without activating')]
build host=hostname:
    @just _info "Building NixOS config for {{host}}"
    nixos-rebuild build --flake .#{{host}} --no-update-lock-file

[group('nixos')]
[doc('Dry-run showing what would change')]
dry-run host=hostname:
    @just _info "Dry-run for {{host}}"
    nixos-rebuild dry-activate --flake .#{{host}} --no-update-lock-file

[group('nixos')]
[doc('Rollback to previous generation')]
[confirm('Roll back to previous generation?')]
rollback:
    @just _warn "Rolling back to previous generation"
    nixos-rebuild switch --rollback

[group('nixos')]
[doc('List NixOS generations')]
generations:
    nixos-rebuild list-generations

# ─── Darwin (macOS) ────────────────────────────────

[group('darwin')]
[doc('Rebuild Darwin (optionally specify host)')]
darwin host=hostname:
    @just _info "Rebuilding Darwin for {{host}}"
    darwin-rebuild switch --flake .#{{host}}

[group('darwin')]
[doc('Build Darwin config without activating')]
darwin-build host=hostname:
    @just _info "Building Darwin config for {{host}}"
    darwin-rebuild build --flake .#{{host}}

[group('darwin')]
[doc('Check Darwin config')]
darwin-check host=hostname:
    @just _info "Checking Darwin config for {{host}}"
    darwin-rebuild check --flake .#{{host}}

[group('darwin')]
[doc('Bootstrap nix-darwin on a new Mac')]
darwin-bootstrap host=hostname:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Installing nix-darwin for {{host}}..."
    nix run nix-darwin -- switch --flake .#{{host}}

# ─── Home Manager ─────────────────────────────────

[group('home')]
[doc('Switch home-manager (optionally specify user@host)')]
home target=(user + "@" + hostname):
    @just _info "Switching home-manager for {{target}}"
    home-manager switch --flake ./home#{{target}} --no-update-lock-file

# ─── Flake ────────────────────────────────────────

[group('flake')]
[doc('Update flake inputs (optionally specify input)')]
update *input:
    @just _info "Updating flake inputs{{ if input != '' { ': ' + input } else { '' } }}"
    nix flake update {{input}}

[group('home')]
[doc('Update home flake inputs (optionally specify input)')]
home-update *input:
    @just _info "Updating home flake inputs{{ if input != '' { ': ' + input } else { '' } }}"
    nix flake update {{input}} --flake ./home

[group('flake')]
[doc('Show flake outputs')]
outputs:
    nix flake show

[group('flake')]
[doc('Check flake health')]
check:
    @just _info "Checking flake"
    nix flake check

# ─── Secrets ──────────────────────────────────────

[group('secrets')]
[doc('Set up local age key from SSH key (one-time)')]
age-setup:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p ~/.config/sops/age
    if [ -f ~/.config/sops/age/keys.txt ]; then
        echo "Age key already exists at ~/.config/sops/age/keys.txt"
        grep "public key:" ~/.config/sops/age/keys.txt || true
        exit 0
    fi
    ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
    chmod 600 ~/.config/sops/age/keys.txt
    echo "Created ~/.config/sops/age/keys.txt"
    echo "Add this public key to .sops.yaml:"
    ssh-to-age -i ~/.ssh/id_ed25519.pub

[group('secrets')]
[doc('Re-encrypt all secrets with current keys')]
secrets-rekey:
    @just _info "Re-encrypting secrets"
    find . -name "*.yaml" \( -path "*/secrets/*" -o -name "secret.enc.yaml" \) \
        ! -name "*.template" -type f \
        -exec sh -c 'echo "Updating: $1" && sops updatekeys -y "$1"' _ {} \;

[group('secrets')]
[doc('Edit a secret file')]
secrets-edit file:
    sops {{file}}

[group('secrets')]
[doc('Create secret from template')]
secrets-create template:
    #!/usr/bin/env bash
    set -euo pipefail
    template="{{template}}"
    target="${template%.template}"
    if [ -f "$target" ]; then
        echo "Error: $target already exists"
        exit 1
    fi
    cp "$template" "$target"
    echo "Created $target - edit and encrypt with: just secrets-encrypt $target"

[group('secrets')]
[doc('Encrypt a plaintext secret file')]
secrets-encrypt file:
    @just _info "Encrypting {{file}}"
    sops -e -i {{file}}

[group('secrets')]
[doc('Decrypt a secret to stdout')]
secrets-decrypt file:
    sops -d {{file}}

[group('secrets')]
[doc("Get host's age public key from SSH host key")]
host-key host="mini":
    ssh {{host}} "cat /etc/ssh/ssh_host_ed25519_key.pub" | ssh-to-age

# ─── Deploy ───────────────────────────────────────

[group('deploy')]
[doc('Deploy to remote host via SSH')]
deploy host:
    @just _info "Deploying to {{host}}"
    nixos-rebuild switch --flake .#{{host}} --target-host {{host}} --use-remote-sudo

# ─── Kubernetes / ArgoCD ──────────────────────────

[group('k8s')]
[doc('Bootstrap ArgoCD (first-time setup)')]
argocd-setup:
    @just _info "Bootstrapping ArgoCD"
    kubectl create namespace argocd || true
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
    kubectl apply -f manifests/argocd/app-of-apps.yaml

[group('k8s')]
[doc('Get ArgoCD admin password')]
argocd-password:
    @kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

[group('k8s')]
[doc('Port-forward ArgoCD UI to localhost:8080')]
argocd-ui:
    @just _info "ArgoCD UI at https://localhost:8080"
    kubectl port-forward svc/argocd-server -n argocd 8080:443

# ─── ZFS ─────────────────────────────────────────

[group('zfs')]
[doc('Show pool status')]
zfs-status:
    zpool status

[group('zfs')]
[doc('List datasets')]
zfs-list:
    zfs list

[group('zfs')]
[doc('List snapshots')]
zfs-snapshots:
    zfs list -t snapshot

[group('zfs')]
[doc('Create manual snapshot')]
zfs-snapshot dataset:
    @just _info "Creating snapshot of {{dataset}}"
    zfs snapshot {{dataset}}@manual-$(date +%Y%m%d-%H%M%S)

[group('zfs')]
[doc('Start scrub')]
zfs-scrub pool="rpool":
    @just _info "Starting scrub on {{pool}}"
    zpool scrub {{pool}}

# ─── System ──────────────────────────────────────

[group('system')]
[doc('Check system status')]
status:
    @just _info "Host: {{hostname}}"
    @just _info "NixOS Generation"
    @nixos-rebuild list-generations 2>/dev/null | tail -5 || echo "Not NixOS"
    @echo ""
    @just _info "Flake Inputs"
    @nix flake metadata --json 2>/dev/null | jq -r '.locks.nodes | to_entries[] | select(.value.locked) | "\(.key): \(.value.locked.rev[:8] // "N/A")"' || echo "No flake.lock"

[group('system')]
[doc('Garbage collect old generations')]
[confirm('Delete old generations and garbage collect?')]
gc:
    @just _info "Garbage collecting"
    nix-collect-garbage -d

[group('system')]
[doc('Optimize nix store')]
optimize:
    @just _info "Optimizing nix store"
    nix-store --optimize
