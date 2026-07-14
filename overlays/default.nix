{ inputs }:
final: prev: {
  unstable = import inputs.nixos-unstable {
    inherit (prev) system;
    config.allowUnfree = true;
  };
}
