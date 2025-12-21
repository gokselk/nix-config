# macOS system defaults
{ config, lib, pkgs, ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      # Keyboard
      AppleKeyboardUIMode = 3;  # Full keyboard access
      ApplePressAndHoldEnabled = false;  # Key repeat instead of accent menu
      InitialKeyRepeat = 15;  # Delay before key repeat
      KeyRepeat = 2;  # Key repeat speed

      # Mouse/Trackpad
      AppleShowScrollBars = "WhenScrolling";

      # Disable auto-corrections
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      # Interface
      AppleInterfaceStyle = "Dark";  # Dark mode
      AppleShowAllExtensions = true;

      # Expand save/print panels by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;

      # Disable UI sounds
      "com.apple.sound.beep.feedback" = 0;
    };

    # Login window
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    # Screen capture
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
    };

    # Trackpad
    trackpad = {
      Clicking = true;  # Tap to click
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  # Keyboard mappings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
