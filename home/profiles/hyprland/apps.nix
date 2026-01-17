# Desktop applications
# Packages, session variables, XDG, mpv, Chrome policies
{ config, pkgs, lib, ... }:
{
  # Wayland utilities and desktop applications
  home.packages = with pkgs; [
    # Screenshot tools
    grim
    slurp
    satty

    # Clipboard
    wl-clipboard
    cliphist

    # File manager
    nautilus

    # Audio control
    pavucontrol
    pamixer

    # Brightness control
    brightnessctl

    # Misc Wayland tools
    wlr-randr
    wev

    # Browser
    google-chrome

    # Editor
    vscode-fhs

    # Media
    vlc
    spotify

    # Communication
    vesktop
    telegram-desktop

    # Documents
    typst
    tinymist        # Typst LSP

    # Productivity
    obsidian

    # Screen recording/streaming
    obs-studio

    # Fonts
    corefonts      # Arial, Times New Roman, Courier New, etc.
    vista-fonts    # Calibri, Cambria, Consolas, etc.
    inter          # Modern UI font

    # Utilities
    qbittorrent-enhanced
    bitwarden-desktop

    # KDE apps
    kdePackages.okular      # PDF/document viewer
    kdePackages.dolphin     # File manager
    kdePackages.gwenview    # Image viewer
    kdePackages.ark         # Archive manager
  ];

  # Desktop environment variables
  home.sessionVariables = {
    BROWSER = "google-chrome-stable";
    TERMINAL = "ghostty";
  };

  # mpv with gpu-next, vulkan, hq profile
  programs.mpv = {
    enable = true;
    config = {
      profile = "high-quality";
      vo = "gpu-next";
      gpu-api = "vulkan";
      hwdec = "vulkan";
    };
  };

  # Chrome privacy/security policies
  # Note: Translation (TranslateEnabled) intentionally left enabled
  xdg.configFile."google-chrome/policies/managed/policies.json".text = builtins.toJSON {
    # Security
    HttpsOnlyMode = "force_enabled";
    SafeBrowsingProtectionLevel = 1;  # Standard protection
    ShowFullUrlsInAddressBar = true;
    DnsOverHttpsMode = "secure";
    DnsOverHttpsTemplates = "https://1.1.1.1/dns-query https://9.9.9.9/dns-query";

    # Privacy - disable telemetry and Google services
    MetricsReportingEnabled = false;
    SafeBrowsingExtendedReportingEnabled = false;
    UrlKeyedAnonymizedDataCollectionEnabled = false;
    SpellCheckServiceEnabled = false;
    AlternateErrorPagesEnabled = false;
    SearchSuggestEnabled = false;
    NetworkPredictionOptions = 2;  # Disabled
    BrowserSignin = 0;
    SyncDisabled = true;
    BackgroundModeEnabled = false;
    ClickToCallEnabled = false;
    GoogleSearchSidePanelEnabled = false;
    PromotionalTabsEnabled = false;
    ShoppingListEnabled = false;
    PaymentMethodQueryEnabled = false;
    PasswordManagerEnabled = false;  # Using Bitwarden
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    RemoteDebuggingAllowed = false;

    # Privacy - cookies and tracking
    BlockThirdPartyCookies = true;
    WebRtcIPHandling = "disable_non_proxied_udp";
    EnableMediaRouter = false;

    # Privacy - disable AI features
    GenAIDefaultSettings = 2;  # Disabled
    CreateThemesSettings = 2;
    HelpMeWriteSettings = 2;
    TabOrganizerSettings = 2;

    # Privacy - device access (ask permission, notifications blocked)
    DefaultNotificationsSetting = 2;
    DefaultGeolocationSetting = 3;
    DefaultSensorsSetting = 3;
    DefaultWebUsbGuardSetting = 3;

    # Disable autoplay
    AutoplayAllowed = false;

  };
}
