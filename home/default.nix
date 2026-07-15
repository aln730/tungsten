{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../modules/home-manager/shell.nix
    ../modules/home-manager/git.nix
    ../modules/home-manager/editors.nix
    ../modules/home-manager/programming.nix
    ../modules/home-manager/desktop.nix
    ../modules/home-manager/dev.nix
  ];

  home.username = "zxcv";
  home.homeDirectory = "/home/zxcv";

  # Pins the baseline behavior of Home-Manager-managed programs.
  # Do not bump this on upgrades; it exists for backwards-compat, not
  # version tracking. See the Home Manager release notes before ever
  # changing it.
  home.stateVersion = "26.05";

  # Lets Home Manager manage itself (adds the `home-manager` CLI).
  programs.home-manager.enable = true;
}
