{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p16s-intel-gen3
    ./tungsten/hardware-configuration.nix
    ../modules/nixos/desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "tungsten";
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true;

  sops.defaultSopsFile = ../secrets/tungsten.yaml;
  sops.age.keyFile = "var/lib/sops-nix/key.txt";

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
