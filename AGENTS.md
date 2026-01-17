# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

```bash
# NixOS rebuild (current host)
just rebuild

# Darwin/macOS rebuild (current host)
just darwin

# Home-manager switch
just home

# Update flake inputs
just update

# Test config without switching
just test

# Secrets
just secrets-edit <file>      # Edit encrypted secret
just secrets-rekey            # Re-encrypt all after key change
just host-key mini            # Get host's age public key

# Kubernetes
just argocd-setup             # Bootstrap ArgoCD
just argocd-password          # Get admin password
```

## Architecture

Two-flake structure:
- **Root flake** (`flake.nix`): NixOS and Darwin system configurations
- **Home flake** (`home/flake.nix`): Standalone home-manager configurations

### System Configurations (flake.nix)

Uses `mkHost` helper for NixOS and `mkDarwin` for macOS:
- `nixosConfigurations.mini` - Main server (AMD Ryzen 6800H)
- `nixosConfigurations.desktop-wsl` - WSL instance
- `darwinConfigurations.goksel-air` - MacBook Air M2

Host structure: `hosts/<hostname>/default.nix` imports hardware, networking, and modules from `modules/nixos/` or `modules/darwin/`.

### Home Manager (home/flake.nix)

Uses `mkHome` helper with composable profiles:
- `profiles/core` - Git, basic config
- `profiles/shell` - Zsh, bash, starship
- `profiles/cli` - CLI tools
- `profiles/development` - Dev tools, k8s, cloud CLIs
- `profiles/hyprland` - Desktop environment (Linux)
- `profiles/darwin` - macOS-specific

Configuration: `home/users/<username>/default.nix`

### Kubernetes (GitOps via ArgoCD)

ArgoCD watches `manifests/apps/` and auto-syncs to k3s cluster on mini.

Each app follows pattern:
- `manifests/apps/<app>/application.yaml` - ArgoCD Application
- `manifests/apps/<app>/kustomization.yaml` - Kustomize config
- `manifests/apps/<app>/secret.enc.yaml` - SOPS-encrypted secrets (ksops)

### Secrets (SOPS + age)

Configuration in `.sops.yaml`. Three encryption contexts:
- `secrets/*.yaml` - NixOS secrets (user + host keys)
- `home/secrets/*.yaml` - User secrets (user key only)
- `manifests/*secret*.yaml` - Kubernetes secrets (user + host for ksops)

SSH host key auto-converts to age key for decryption on servers.

## Key Files

| Path | Purpose |
|------|---------|
| `hosts/<hostname>/default.nix` | Host entry point |
| `hosts/<hostname>/disk-config.nix` | Disko ZFS layout |
| `modules/nixos/` | NixOS modules (core, networking, storage, secrets) |
| `modules/darwin/` | Darwin modules (core, system, homebrew) |
| `home/profiles/` | Composable home-manager profiles |
| `manifests/argocd/app-of-apps.yaml` | Root ArgoCD application |
| `.sops.yaml` | SOPS encryption rules + age keys |
