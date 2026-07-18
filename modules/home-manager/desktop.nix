{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    spotify
    alacritty
    firefox
    gnomeExtensions.vitals
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "Vitals@CoreCoding.com"
      ];
    };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [ "_processor_usage_" "_memory_usage_" "_temperature_" "_network-rx_" ];
      position-in-panel = 1;
    };
  };
}
