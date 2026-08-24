{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x250
    ./x250/hardware-configuration.nix
    ../modules/nixos/desktop.nix
  ];
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    efiSupport = false;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.plymouth.enable = true;
  boot.plymouth.win98se.label.mode = "release";
  networking.hostName = "x250";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d --delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
  services.fstrim.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
    };
  };
  services.thermald.enable = true;
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = false;
  hardware.trackpoint.enable = true;
  services.thinkfan = {
    enable = true;
    levels = [
      [ 0 0 55 ]
      [ 1 48 60 ]
      [ 2 50 65 ]
      [ 3 52 70 ]
      [ 4 56 75 ]
      [ 7 60 32767 ]
    ];
  };

  sops.defaultSopsFile = ../secrets/x250.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.secrets."eduroam-nmconnection" = {
    path = "/etc/NetworkManager/system-connections/eduroam.nmconnection";
    owner = "root";
    group = "root";
    mode = "0600";
    restartUnits = [ "NetworkManager.service" ];
  };

  users.users.zxcv = {
    isNormalUser = true;
    description = "zxcv";
    home = "/home/zxcv";
    extraGroups = [
      "wheel"
      "networkmanager"
      "dialout"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  system.stateVersion = "26.05";
}
