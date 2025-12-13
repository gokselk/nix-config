# Nix Home Lab Commands
# Run `just` to see all available commands

# Default: show help
default:
    @just --list

# --- Variables ---
hostname := `hostname`
user := `whoami`

# --- NixOS (Linux only) ---

# Rebuild NixOS for current host
rebuild:
    sudo nixos-rebuild switch --flake .#{{hostname}}

# Rebuild NixOS for specific host
rebuild-host host:
    sudo nixos-rebuild switch --flake .#{{host}}

# Test NixOS config without switching
test:
    sudo nixos-rebuild test --flake .#{{hostname}}

# Build NixOS config without activating
build:
    nixos-rebuild build --flake .#{{hostname}}

# --- Home Manager (all platforms) ---

# Switch home-manager for current host
home:
    home-manager switch --flake ./home#{{user}}@{{hostname}}

# Switch home-manager for specific user@host
home-switch target:
    home-manager switch --flake ./home#{{target}}

# --- Flake Management ---

# Update all flake inputs
update:
    nix flake update

# Update specific input
update-input input:
    nix flake update {{input}}

# Show flake outputs
outputs:
    nix flake show

# --- Secrets (SOPS + age) ---

# Set up local age key from SSH key (one-time setup)
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

# Re-encrypt all secrets with current keys in .sops.yaml
secrets-update:
    #!/usr/bin/env bash
    set -euo pipefail
    find . -name "*.yaml" \( -path "*/secrets/*" -o -name "secret.enc.yaml" \) \
        ! -name "*.template" -type f \
        -exec sh -c 'echo "Updating: $1" && sops updatekeys -y "$1"' _ {} \;

# Edit a secret file
secrets-edit file:
    sops {{file}}

# Create secret from template
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

# Encrypt a plaintext secret file
secrets-encrypt file:
    sops -e -i {{file}}

# Decrypt a secret to stdout
secrets-decrypt file:
    sops -d {{file}}

# Get host's age public key (run after NixOS rebuild)
host-key host="mini":
    ssh {{host}} "sudo cat /var/lib/sops-nix/key.txt" | grep "public key:" | cut -d: -f2 | tr -d ' '

# --- Remote Deployment ---

# Deploy to remote host via SSH
deploy host:
    nixos-rebuild switch --flake .#{{host}} --target-host {{host}} --use-remote-sudo

# --- Kubernetes / ArgoCD ---

# Bootstrap ArgoCD (first-time setup)
argocd-bootstrap:
    kubectl create namespace argocd || true
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
    kubectl apply -f manifests/argocd/app-of-apps.yaml

# Get ArgoCD admin password
argocd-password:
    @kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

# Port-forward ArgoCD UI
argocd-ui:
    kubectl port-forward svc/argocd-server -n argocd 8080:443

# --- Utilities ---

# Check system status
status:
    @echo "=== Host: {{hostname}} ==="
    @echo "=== NixOS Generation ==="
    @nixos-rebuild list-generations 2>/dev/null | tail -5 || echo "Not NixOS"
    @echo ""
    @echo "=== Flake Inputs ==="
    @nix flake metadata --json 2>/dev/null | jq -r '.locks.nodes | to_entries[] | select(.value.locked) | "\(.key): \(.value.locked.rev[:8] // "N/A")"' || echo "No flake.lock"

# Garbage collect old generations
gc:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d

# Optimize nix store
optimize:
    sudo nix-store --optimize
