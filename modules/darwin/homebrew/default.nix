# Homebrew configuration
{ ... }:
{
  imports = [
    ./brew.nix
    ./cask.nix
    ./mas.nix
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";  # Remove unlisted casks/formulae
    };

    global = {
      brewfile = true;
      lockfiles = false;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];
  };
}
