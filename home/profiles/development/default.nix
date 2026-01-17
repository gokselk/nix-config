# Development profile
# Tools for software development and DevOps
{ config, pkgs, lib, inputs, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./kubernetes.nix
    ./cloud.nix
    ./languages.nix
  ];

  home.packages = with pkgs; [
    # Development utilities
    lazydocker    # Terminal UI for docker
    delta         # Better git diffs
    httpie        # HTTP client
    usql          # Universal SQL client
    tokei         # Code statistics

    # AI coding agents
    llm.claude-code
  ];

  # Direnv integration
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Lazygit
  programs.lazygit.enable = true;

  # Zoxide (smarter cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Atuin (shell history)
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Tmux for terminal multiplexing
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    escapeTime = 10;
  };
}
