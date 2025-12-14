# Base home-manager profile
# Shared configuration for all users/systems
{ config, pkgs, lib, ... }:
{
  # Home Manager version
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Basic shell configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
    };

    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      g = "git";
      k = "kubectl";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Goksel";
    userEmail = "goksel@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Common packages
  home.packages = with pkgs; [
    # Core utilities
    htop
    btop
    ripgrep
    fd
    jq
    yq-go
    tree
    bat
    eza        # Modern ls replacement
    fastfetch  # System info display

    # Archives
    unzip
    zip
    p7zip
  ];
}
