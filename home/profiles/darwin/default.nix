# macOS-specific home-manager configuration
{ config, pkgs, lib, ... }:
{
  # Disable Linux-only XDG user directories
  xdg.userDirs.enable = lib.mkForce false;

  # macOS-specific packages
  home.packages = with pkgs; [
    # Darwin utilities
    darwin.trash  # Move to trash from CLI
  ];

  # macOS-specific shell aliases
  programs.zsh.shellAliases = {
    # Homebrew
    brewup = "brew update && brew upgrade && brew cleanup";
    brewinfo = "brew info";
    brewsearch = "brew search";

    # macOS system
    showfiles = "defaults write com.apple.finder AppleShowAllFiles YES && killall Finder";
    hidefiles = "defaults write com.apple.finder AppleShowAllFiles NO && killall Finder";
    flushdns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";

    # Quick Look
    ql = "qlmanage -p";

    # Open apps
    code = "open -a 'Visual Studio Code'";
  };

  programs.bash.shellAliases = {
    brewup = "brew update && brew upgrade && brew cleanup";
    flushdns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
  };
}
