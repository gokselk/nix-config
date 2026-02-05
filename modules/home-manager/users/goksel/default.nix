# User-specific configuration for goksel
{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Home directory (auto-detected based on system)
  home.username = "goksel";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/goksel" else "/home/goksel";

  # User-specific packages
  home.packages = with pkgs; [
    # Add user-specific packages here
  ];

  # SSH authorized keys (creates ~/.ssh/authorized_keys)
  home.file.".ssh/authorized_keys".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHTkE/L8j4Awh0xfi38iz9oDKPX7Z+ZDOku6LcBh3tY goksel
  '';

  # User-specific git config (if different from base)
  # programs.git.userEmail = "different@email.com";
}
