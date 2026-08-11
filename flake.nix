{
  description = "packaged northstar related stuff";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      systems,
    }@inputs:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f (
            import nixpkgs {
              overlays = [ rust-overlay.overlays.default ];
              inherit system;
            }
          )
        );
    in
    {
      formatter = eachSystem (pkgs: pkgs.nixfmt-tree);

      packages = eachSystem (pkgs: pkgs.callPackage ./pkgs { inherit inputs; });
    }
    // {
      nixosModules.maxima-service = import ./modules/maxima-service { inherit self; };
    };
}
