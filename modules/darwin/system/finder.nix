# macOS Finder configuration
{
  config,
  lib,
  pkgs,
  ...
}:
{
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true; # Show hidden files
    CreateDesktop = false; # Hide desktop icons
    FXDefaultSearchScope = "SCcf"; # Search current folder by default
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "Nlsv"; # List view
    QuitMenuItem = true; # Allow quitting Finder
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXShowPosixPathInTitle = true; # Show full path in title
  };

  # Show ~/Library folder
  system.activationScripts.postActivation.text = ''
    chflags nohidden ~/Library
  '';
}
