{ config, lib, pkgs, configurationName, unstablePkgs ? pkgs, ... }:

let
  nvimConfigDir = ./files/nvim;
  nvimFiles = lib.filesystem.listFilesRecursive nvimConfigDir;
  nvimHomeFiles = builtins.listToAttrs (map (path: {
    name = ".config/nvim/${lib.removePrefix ((toString nvimConfigDir) + "/") (toString path)}";
    value.source = path;
  }) nvimFiles);
in
{
  imports = [
    ./codex
    ./pi
    ./skills
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  home.file = {
    ".npmrc".text = ''
prefix=${config.home.homeDirectory}/.npm-global
'';
    ".tmux.conf".source = ./files/tmux/tmux.conf;
    ".claude/CLAUDE.md".source = ./files/claude/CLAUDE.md;
    ".latexmkrc".source = ./files/latexmkrc;
    ".vimrc".source = ./files/vimrc;
  } // nvimHomeFiles;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "direnv-clear-cache";
      runtimeInputs = [ pkgs.bash pkgs.coreutils pkgs.findutils ];
      text = ''
        if (( $# != 0 )); then
          printf 'Usage: direnv-clear-cache\n' >&2
          exit 1
        fi

        find -P ${lib.escapeShellArg config.home.homeDirectory} -type d -name .direnv -prune \
          -exec bash -c '
            for directory; do
              rm -rf -- "$directory" || exit 1
              printf "Deleted: %s\n" "$directory"
            done
          ' bash {} +
      '';
    })
    unstablePkgs.neovim
    pkgs.git
    pkgs.gh
    pkgs.ripgrep
    pkgs.fd
    pkgs.bubblewrap
    pkgs.tree
    pkgs.htop
    pkgs.curl
    pkgs.jq
    pkgs.nodejs_24
    pkgs.python3
    pkgs.pnpm
    pkgs.fish
    pkgs.tmux
    pkgs.deno
    pkgs.tree-sitter
    pkgs.fzf
    pkgs.lsd
    pkgs.rust-analyzer
    pkgs.rustfmt
    pkgs.ccls
    pkgs.typescript
    pkgs.typescript-language-server
    pkgs.lua-language-server
    pkgs.sqls
    pkgs.nil
    pkgs.nixd
    pkgs.pyright
    pkgs.cmake
    pkgs.gcc
    pkgs.gnumake
    pkgs.gettext
    pkgs.unzip
    pkgs.universal-ctags
    pkgs.translate-shell
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user = {
      name = "Hikaru Kondo";
      email = "mushin.hudoushin@gmail.com";
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#${configurationName}";
      update = "nix flake update ~/nixos-config && sudo nixos-rebuild switch --flake ~/nixos-config#${configurationName}";
      cleanup = "sudo nix-collect-garbage -d";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#${configurationName}";
      update = "nix flake update ~/nixos-config && sudo nixos-rebuild switch --flake ~/nixos-config#${configurationName}";
      cleanup = "sudo nix-collect-garbage -d";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkOrder 1100 (builtins.readFile ./files/fish/config.fish);
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
