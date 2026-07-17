{ inputs }:
final: prev: {
  unstable = import inputs.nixos-unstable {
    inherit (prev) system;
    config.allowUnfree = true;
  };
  gatekeeper-pam = final.callPackage ../pkgs/gatekeeper-pam.nix { inherit inputs; };
}
