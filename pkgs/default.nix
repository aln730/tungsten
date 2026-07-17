{ pkgs, inputs }:
{
  gatekeeper-pam = pkgs.callPackage ./gatekeeper-pam.nix { inherit inputs; };
}
