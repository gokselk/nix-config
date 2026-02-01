# Rofi configuration
# Application launcher
{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          bg = mkLiteral "#1e1e2e";
          fg = mkLiteral "#cdd6f4";
          accent = mkLiteral "#89b4fa";
          urgent = mkLiteral "#f38ba8";
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
        };
        window = {
          width = mkLiteral "600px";
          border = mkLiteral "2px";
          border-color = mkLiteral "@accent";
          border-radius = mkLiteral "10px";
        };
        inputbar = {
          padding = mkLiteral "10px";
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
        };
        prompt = {
          padding = mkLiteral "0 10px 0 0";
        };
        entry = {
          placeholder = "Search...";
        };
        listview = {
          lines = 8;
          padding = mkLiteral "10px";
        };
        element = {
          padding = mkLiteral "8px";
          border-radius = mkLiteral "5px";
        };
        "element selected" = {
          background-color = mkLiteral "@accent";
          text-color = mkLiteral "@bg";
        };
      };
  };
}
