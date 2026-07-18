{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.gatekeeper-pam;
in
{
  options.services.gatekeeper-pam.enable = lib.mkEnableOption "gatekeeper NFC PAM";

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", GROUP="gatekeeper", MODE="0660", SYMLINK+="gatekeeper-nfc", ENV{ID_MM_DEVICE_IGNORE}="1"
    '';

    users.groups.gatekeeper = { };
    users.users.gatekeeperd = {
      isSystemUser = true;
      group = "gatekeeper";
      extraGroups = [ "dialout" ];
    };

    users.users.gdm.extraGroups = [ "gatekeeper" ];

    sops.secrets."gatekeeper-pam-conf" = {
      sopsFile = ../../secrets/tungsten.yaml;
      path = "/etc/gatekeeper-pam.conf";
      owner = "gatekeeperd";
      group = "gatekeeper";
      mode = "0440";
    };

    systemd.services.gatekeeperd = {
      description = "Gatekeeper NFC daemon";
      wantedBy = [ "multi-user.target" ];
      before = [ "display-manager.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.gatekeeper-pam}/bin/gatekeeperd";
        User = "gatekeeperd";
        Group = "gatekeeper";
        Restart = "always";
        RestartSec = "2s";
        RuntimeDirectory = "gatekeeperd";
        RuntimeDirectoryMode = "0770";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        DeviceAllow = [ "/dev/gatekeeper-nfc rw" ];
        DevicePolicy = "closed";
      };
    };

    systemd.services.display-manager = {
      after = [ "gatekeeperd.service" ];
      wants = [ "gatekeeperd.service" ];
    };
    security.pam.services.gdm-password.rules.auth.gatekeeper = {
      control = "sufficient";
      modulePath = "${pkgs.gatekeeper-pam}/lib/security/pam_gatekeeper.so";
      order = 10000;
    };
  };
}
