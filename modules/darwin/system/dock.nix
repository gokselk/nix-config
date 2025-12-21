# macOS Dock configuration
{ config, lib, pkgs, ... }:
{
  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.0;
    autohide-time-modifier = 0.2;
    expose-animation-duration = 0.1;
    launchanim = false;
    mineffect = "scale";
    minimize-to-application = true;
    mru-spaces = false;  # Don't rearrange spaces based on recent use
    orientation = "bottom";
    show-recents = false;
    showhidden = true;  # Dim hidden app icons
    static-only = false;
    tilesize = 48;

    # Hot corners (1 = disabled)
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };
}
