{
  description = "gkatai's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
  };

  outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      gk-laptop = lib.nixosSystem {
        inherit system;

        modules = [
	  ./configuration.nix 
	];
      };
    };
  };
}

