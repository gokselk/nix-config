# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# NixOS rebuild (current host)
just rebuild

# Darwin/macOS rebuild (current host)
just darwin
just darwin-bootstrap <host>  # First-time nix-darwin install

# Update flake inputs
just update

# Test/validate without switching
just test                     # Test NixOS config
just dry-run                  # Preview what would change
just check                    # Validate flake

# Secrets
just secrets-edit <file>      # Edit encrypted secret
just secrets-rekey            # Re-encrypt after key change
just host-key <hostname>      # Get host's age public key

# Maintenance
just gc                       # Garbage collect old generations
just deploy <host>            # Deploy to remote host via SSH

# Install
./scripts/install.sh <hostname> <target-host>  # nixos-anywhere install
```

## Architecture

Single flake with unified home-manager as NixOS/Darwin module.

### Hosts

- `nixosConfigurations.hl-node01` - Headless Incus server (AMD Ryzen 6800H)
- `nixosConfigurations.gk-desktop-wsl` - WSL instance with dev tools
- `darwinConfigurations.gk-air` - MacBook Air M2

Host entry: `hosts/<hostname>/default.nix`
Common config: `hosts/common/` (NixOS: `default.nix`, Darwin: `darwin.nix`)

### Modules

```
modules/
├── nixos/           # NixOS system modules
│   ├── core/        # boot, nix, packages
│   ├── networking/  # firewall, ssh, tailscale
│   ├── storage/     # ZFS
│   ├── secrets/     # SOPS-nix
│   └── desktop/     # GNOME, Hyprland, KDE (optional)
├── darwin/          # macOS modules
│   ├── core/        # nix, packages
│   ├── system/      # defaults, dock, finder
│   └── homebrew/    # casks, formulae, mas
└── home-manager/    # Home-manager profiles
    ├── profiles/    # Composable (core, shell, cli, development, darwin, gnome...)
    └── users/       # User-specific config
```

### Secrets (SOPS + age)

```
secrets/
├── hosts/common/    # Host secrets (user + host keys)
└── users/goksel/    # User secrets (user key only)
```

SOPS rules in `.sops.yaml`. SSH host key converts to age key for decryption.

## Key Patterns

- `mkHost` / `mkDarwin` helpers in `flake.nix` create system configs
- Home-manager profiles imported via `hosts/common/users.nix` (NixOS) or `hosts/common/darwin.nix`
- Per-host home-manager additions in host's `default.nix`
