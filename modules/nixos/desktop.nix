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
}
