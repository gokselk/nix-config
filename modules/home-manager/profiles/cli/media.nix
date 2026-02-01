# Media CLI tools
{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    yt-dlp # Video/audio downloader
  ];
}
