{
  description = "My multi-host, multi-user NixOS config";

  # Define inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };


    disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";
  };

  # Outputs configuration (for NixOS and Home Manager)
  outputs = { nixpkgs, home-manager, disko, ... }@inputs: let
    system = "x86_64-linux";

    # Base configuration to be shared
    baseModules = [
      ./hosts/base-config/default.nix  # Common NixOS settings
    ];

    # Define machine-specific configurations
    machines = {
      # laptop
      "thinkpad-t480-jp" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        inherit system;
        modules = baseModules ++ [ ./hosts/thinkpad-t480-jp/configuration.nix ];  
      };

      # desktop PC
      "thinkpad-t480-th" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        inherit system;
        modules = baseModules ++ [ ./hosts/thinkpad-t480-th/configuration.nix ];  
      };

      # server
      "mac-hp" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        inherit system;
        modules = baseModules ++ [ ./hosts/mac-hp/configuration.nix ];  
      };
    };

    # Define user-specific configurations
    users = {
      "pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home/pc/home.nix ];  
      };

      "server" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home/server/home.nix ];  
      };
    };

  in {
    # Export machine-specific NixOS configurations
    nixosConfigurations = machines;

    # Export user-specific Home Manager configurations
    homeConfigurations = users;
  };
}

