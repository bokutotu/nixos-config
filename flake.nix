{
  description = "Hikaru's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Alacritty 0.16.1: avoid the X11/fcitx5 input regression in 0.17.0.
    nixpkgs-alacritty.url = "github:NixOS/nixpkgs/25f538306313eae3927264466c70d7001dcea1df";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-chatgpt.url = "github:Moraxyc/nixpkgs/chatgpt-linux";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-alacritty, nixpkgs-unstable, nixpkgs-chatgpt, home-manager, ... }: {
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

        home-manager.extraSpecialArgs.alacrittyPkgs = import nixpkgs-alacritty {
          system = pkgs.stdenv.hostPlatform.system;
        };

        home-manager.extraSpecialArgs.chatgptPkgs = import nixpkgs-chatgpt {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };

      nvidia = { pkgs, ... }: {
        imports = [ ./profiles/nvidia.nix ];
        _module.args.unstablePkgs = import nixpkgs-unstable {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };

      gpu-vm = import ./hosts/gpu-vm {
        profiles = self.nixosModules;
      };
    };

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.profiles = self.nixosModules;
      modules = [ ./hosts/laptop/configuration.nix ];
    };
  };
}
