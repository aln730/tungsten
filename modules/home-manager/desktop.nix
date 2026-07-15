{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    spotify
    alacritty
    firefox
  ];
}
