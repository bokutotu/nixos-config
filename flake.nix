{
  description = "Hikaru's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-chatgpt.url = "github:Moraxyc/nixpkgs/chatgpt-linux";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-chatgpt, home-manager, ... }: {
    nixosModules = {
      dev-shell = { config, lib, pkgs, ... }: {
        imports = [
          home-manager.nixosModules.home-manager
          ./profiles/dev-shell.nix
        ];

        home-manager.users.hikaru._module.args.configurationName =
          lib.mkDefault config.networking.hostName;

        home-manager.extraSpecialArgs = {
          unstablePkgs = import nixpkgs-unstable {
            system = pkgs.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        };
      };

      desktop = { pkgs, ... }: {
        imports = [ ./profiles/desktop.nix ];

        home-manager.extraSpecialArgs.chatgptPkgs = import nixpkgs-chatgpt {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };

      nvidia = import ./profiles/nvidia.nix;
    };

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.profiles = self.nixosModules;
      modules = [ ./hosts/laptop/configuration.nix ];
    };
  };
}
