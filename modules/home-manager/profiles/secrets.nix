# User secrets via sops-nix
# For user-specific secrets like API tokens, SSH keys, etc.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops = {
    # Use SSH key converted to age format
    # Generate with: ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # Default secrets file for user secrets
    defaultSopsFile = ../secrets/user-secrets.yaml;

    # Example user secrets (uncomment when user-secrets.yaml exists)
    # secrets = {
    #   "gh-token" = {
    #     path = "${config.home.homeDirectory}/.config/gh/token";
    #   };
    #   "api-keys/openai" = {};
    # };
  };
}
