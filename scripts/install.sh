#!/usr/bin/env bash
# NixOS installation script using nixos-anywhere
# Usage: ./install.sh <hostname> <target-host>
# Example: ./install.sh hl-node01 root@192.168.1.100

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 <hostname> <target-host>"
    echo ""
    echo "Arguments:"
    echo "  hostname     NixOS configuration name (e.g., hl-node01, gk-desktop-wsl)"
    echo "  target-host  SSH target (e.g., root@192.168.1.100)"
    echo ""
    echo "Example:"
    echo "  $0 hl-node01 root@192.168.1.100"
    echo ""
    echo "Prerequisites:"
    echo "  1. Target machine booted from NixOS installer or has SSH access"
    echo "  2. Root SSH access enabled on target"
    echo "  3. Update hosts/<hostname>/disk-config.nix with correct disk device"
    echo "  4. Generate unique hostId: head -c 8 /etc/machine-id"
    exit 1
}

if [[ $# -lt 2 ]]; then
    usage
fi

HOST="${1}"
TARGET="${2}"

# Check if configuration exists
if [[ ! -d "${FLAKE_DIR}/hosts/${HOST}" ]]; then
    echo -e "${RED}Error: Host configuration '${HOST}' not found${NC}"
    echo "Available hosts:"
    ls -1 "${FLAKE_DIR}/hosts/" | grep -v common
    exit 1
fi

echo -e "${GREEN}=== NixOS Installation ===${NC}"
echo -e "Host:   ${YELLOW}${HOST}${NC}"
echo -e "Target: ${YELLOW}${TARGET}${NC}"
echo -e "Flake:  ${YELLOW}${FLAKE_DIR}${NC}"
echo ""

# Confirm before proceeding
echo -e "${RED}WARNING: This will ERASE ALL DATA on the target disk!${NC}"
read -p "Are you sure you want to continue? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo -e "${GREEN}Starting nixos-anywhere...${NC}"
echo ""

# Run nixos-anywhere
nix run github:nix-community/nixos-anywhere -- \
    --flake "${FLAKE_DIR}#${HOST}" \
    --target-host "${TARGET}" \
    --build-on remote

echo ""
echo -e "${GREEN}=== Installation Complete ===${NC}"
echo ""
echo "Next steps:"
echo "  1. Wait for the system to reboot"
echo "  2. SSH into the new system: ssh goksel@<ip-address>"
echo "  3. Change the initial password: passwd"
echo "  4. Set up Tailscale: sudo tailscale up"
