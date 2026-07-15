{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  # Plasma pulls in a lot of KDE's own stack (Discover, KMail, etc).
  # Trim what you don't want here rather than fighting it upstream.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
    plasma-welcome
  ];

  # Needed for GTK apps (and some Electron apps like Discord) to
  # render/theme correctly under Plasma/Wayland.
  programs.dconf.enable = true;

  # PipeWire is the expected audio stack alongside Plasma 6.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = false;
 
  environment.systemPackages = with pkgs; [
    pritunl-client
  ];

  systemd.packages = [ pkgs.pritunl-client ];
  systemd.services.pritunl-client.wantedBy = [ "multi-user.target" ];

  environment.etc."nfc/libnfc.conf".text = ''
  device.name = "pn532_uart"
  device.connstring = "pn532_uart:/dev/ttyUSB0"
  allow_autoscan = true
  allow_intrusive_scan = false
  log_level = 1
  '';
}
