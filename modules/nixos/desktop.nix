{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;

  services.desktopManager.gnome.enable = true;
  # GNOME pulls in a lot of its own stack (Geary, Epiphany, etc).
  # Trim what you don't want here rather than fighting it upstream.
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany
    geary
  ];
  # Needed for GTK apps (and some Electron apps like Discord) to
  # render/theme correctly.
  programs.dconf.enable = true;
  # PipeWire is the expected audio stack alongside GNOME.
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
  services.udev.packages = [ pkgs.qFlipper ];
  environment.etc."nfc/libnfc.conf".text = ''
  device.name = "pn532_uart"
  device.connstring = "pn532_uart:/dev/ttyUSB0"
  allow_autoscan = true
  allow_intrusive_scan = false
  log_level = 1
  '';
}
