{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    discord
    spotify
    alacritty
    firefox
    gnomeExtensions.vitals
    qFlipper
    vscode
  ];

  home.file.".wallpaper.jpg".source = ../../home/wallpapers/tungsten.jpg;
  
  xdg.configFile."autostart/gnome-keyring-pkcs11.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
  xdg.configFile."autostart/gnome-keyring-secrets.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/.wallpaper.jpg";
      picture-uri-dark = "file://${config.home.homeDirectory}/.wallpaper.jpg";
      picture-options = "zoom";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "Vitals@CoreCoding.com"
      ];
    };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_processor_usage_"
        "_memory_usage_"
        "_temperature_"
        "_network-rx_"
      ];
      position-in-panel = 1;
    };
  };
}
