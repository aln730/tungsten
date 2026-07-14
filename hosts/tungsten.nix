# hosts/tungsten.nix
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

  sops.defaultSopsFile = ../secrets/tungsten.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  sops.secrets."eduroam/ca-cert" = {
    format = "binary";
    sopsFile = ../secrets/tungsten.yaml;
  };

  sops.secrets."eduroam/client-cert" = {
    format = "binary";
    sopsFile = ../secrets/tungsten.yaml;
  };

  sops.secrets."eduroam/private-key" = {
    format = "binary";
    sopsFile = ../secrets/tungsten.yaml;
  };

  sops.secrets."eduroam/private-key-password-env" = {
    sopsFile = ../secrets/tungsten.yaml;
  };

  networking.networkmanager.enable = true;

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.sops.secrets."eduroam/private-key-password-env".path
    ];

    profiles = {
      eduroam = {
        connection = {
          id = "eduroam";
          type = "wifi";
          autoconnect = true;
        };

        wifi = {
          mode = "infrastructure";
          ssid = "eduroam";
        };

        wifi-security = {
          key-mgmt = "wpa-eap";
        };

        "802-1x" = {
          eap = "tls";
          identity = "asg7201@rit.edu";
          anonymous-identity = "anonymous@rit.edu";

          ca-cert = config.sops.secrets."eduroam/ca-cert".path;
          client-cert = config.sops.secrets."eduroam/client-cert".path;
          private-key = config.sops.secrets."eduroam/private-key".path;
          private-key-password = "$EDUROAM_PRIVATE_KEY_PASSWORD";
        };

        ipv4.method = "auto";
        ipv6 = {
          method = "auto";
          addr-gen-mode = "stable-privacy";
        };
      };
    };
  };

  users.users.zxcv = {
    isNormalUser = true;
    description = "zxcv";
    home = "/home/zxcv";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  system.stateVersion = "26.05";
}
