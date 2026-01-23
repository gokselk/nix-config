# AGENTS.md

This file provides guidance to AI coding assistants when working with code in this repository.

## Common Commands

```bash
# NixOS rebuild (current host)
just rebuild

# Darwin/macOS rebuild (current host)
just darwin
just darwin-bootstrap <host>  # First-time nix-darwin install

# Home-manager switch
just home

# Update flake inputs
just update

# Test/validate without switching
just test                     # Test NixOS config
just dry-run                  # Preview what would change
just check                    # Validate flake

# Secrets
just secrets-edit <file>      # Edit encrypted secret
just secrets-rekey            # Re-encrypt all after key change
just host-key hl-node01       # Get host's age public key

# Maintenance
just gc                       # Garbage collect old generations
just deploy <host>            # Deploy to remote host via SSH
```

## Architecture

Two-flake structure:
- **Root flake** (`flake.nix`): NixOS and Darwin system configurations
- **Home flake** (`home/flake.nix`): Standalone home-manager configurations

### System Configurations (flake.nix)

Uses `mkHost` helper for NixOS and `mkDarwin` for macOS:
- `nixosConfigurations.hl-node01` - Main homelab server (Nipogi E3B, AMD Ryzen 6800H)
- `nixosConfigurations.gk-desktop-wsl` - WSL instance
- `darwinConfigurations.gk-air` - MacBook Air M2

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

### Secrets (SOPS + age)

Configuration in `.sops.yaml`. Two encryption contexts:
- `secrets/*.yaml` - NixOS secrets (user + host keys)
- `home/secrets/*.yaml` - User secrets (user key only)

SSH host key auto-converts to age key for decryption on servers.

## Key Files

| Path | Purpose |
|------|---------|
| `hosts/<hostname>/default.nix` | Host entry point |
| `hosts/<hostname>/disk-config.nix` | Disko ZFS layout |
| `modules/nixos/` | NixOS modules (core, networking, storage, secrets) |
| `modules/darwin/` | Darwin modules (core, system, homebrew) |
| `home/profiles/` | Composable home-manager profiles |
| `.sops.yaml` | SOPS encryption rules + age keys |
