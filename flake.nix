# flake.nix
{
  description = "zxcv's NixOS machine configurations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixos-unstable,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        };
    in
    {
      overlays.default = import ./overlays { inherit inputs; };
      nixosConfigurations.tungsten = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/tungsten.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zxcv = import ./home;
          }
        ];
      };
      homeConfigurations."zxcv@tungsten" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor "x86_64-linux";
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home ];
      };
      packages = forAllSystems (
        system:
        import ./pkgs {
          pkgs = pkgsFor system;
        }
      );
      formatter = forAllSystems (system: (pkgsFor system).nixfmt-rfc-style);
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            name = "tungsten-nixos-shell";
            packages = with pkgs; [
              nixfmt-rfc-style
              nil
            ];
          };
        }
      );
    };
}
