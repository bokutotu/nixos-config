{
  description = "Hikaru's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "hikaru";
      hostname = "laptop";
      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      codexPackage = unstablePkgs.codex.overrideAttrs (finalAttrs: previousAttrs: {
        version = "0.139.0";

        src = unstablePkgs.fetchFromGitHub {
          owner = "openai";
          repo = "codex";
          tag = "rust-v${finalAttrs.version}";
          hash = "sha256-XjzlkBUkBey+P3tFLDYB3ae5oseUfW5tmzhLzqlqj2E=";
        };

        cargoHash = "sha256-8mN4OTRJvt2mBYHQXZS55PSOChLqEIiXwPu2y+2MZ9o=";
        cargoDeps = unstablePkgs.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) pname version src sourceRoot;
          hash = finalAttrs.cargoHash;
        };

        postPatch = ''
          substituteInPlace $cargoDepsCopy/*/webrtc-sys-*/build.rs \
            --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc"
          substituteInPlace Cargo.toml \
            --replace-fail 'codegen-units = 1' ""
        '';
      });
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit unstablePkgs;
        };

        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = {
              inherit codexPackage unstablePkgs;
            };

            home-manager.users.${username} = import ./home/hikaru.nix;
          }
        ];
      };
    };
}
