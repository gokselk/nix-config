# Development profile
# Tools for software development and DevOps
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # Container/Kubernetes tools
    kubectl
    kubernetes-helm
    k9s
    stern         # Multi-pod log tailing
    kubectx       # Context/namespace switching

    # Infrastructure tools
    opentofu      # Open source Terraform fork
    ansible

    # Cloud CLIs
    awscli2
    google-cloud-sdk

    # Development tools
    direnv
    lazygit       # Terminal UI for git
    gh            # GitHub CLI

    # Languages (add as needed)
    go
    python3
    nodejs

    # Editors (terminal)
    neovim
  ];

  # Direnv integration
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Lazygit
  programs.lazygit.enable = true;

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
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";

    extraConfig = ''
      # Enable mouse support
      set -g mouse on

      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1

      # Renumber windows when one is closed
      set -g renumber-windows on
    '';
  };
}
