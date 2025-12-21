# MacBook Air M2 (Personal)
# 16GB RAM, 512GB SSD
{ config, lib, pkgs, inputs, ... }:
{
  networking.hostName = "goksel-air";
  networking.computerName = "Goksel's MacBook Air";

  # Personal-specific home-manager overrides
  home-manager.users.goksel = {
    # Add personal-specific config here if needed
  };
}
