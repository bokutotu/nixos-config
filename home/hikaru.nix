{ config, lib, pkgs, unstablePkgs ? pkgs, codexPackage ? unstablePkgs.codex, ... }:

let
  nvimConfigDir = ./files/nvim;
  nvimFiles = lib.filesystem.listFilesRecursive nvimConfigDir;
  nvimHomeFiles = builtins.listToAttrs (map (path: {
    name = ".config/nvim/${lib.removePrefix ((toString nvimConfigDir) + "/") (toString path)}";
    value.source = path;
  }) nvimFiles);
in
{

  home.username = "hikaru";
  home.homeDirectory = "/home/hikaru";

  home.sessionPath = [
    "${codexPackage}/bin"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  home.file = {
    ".npmrc".text = ''
prefix=${config.home.homeDirectory}/.npm-global
'';
    ".config/fish/config.fish".source = ./files/fish/config.fish;
    ".tmux.conf".source = ./files/tmux/tmux.conf;
    ".wezterm.lua".source = ./files/wezterm/wezterm.lua;
    ".codex/custom_instructions.md".source = ./files/codex/custom_instructions.md;
    ".claude/CLAUDE.md".source = ./files/claude/CLAUDE.md;
    ".latexmkrc".source = ./files/latexmkrc;
    ".vimrc".source = ./files/vimrc;
    ".local/bin/external-monitor-ls" = {
      source = ./files/bin/external-monitor-ls;
      executable = true;
    };
    ".local/bin/external-monitor-use" = {
      source = ./files/bin/external-monitor-use;
      executable = true;
    };
    ".local/bin/external-monitor-off" = {
      source = ./files/bin/external-monitor-off;
      executable = true;
    };
    ".config/lxqt/session.conf".source = ./files/lxqt/session.conf;
    ".config/lxqt/lxqt.conf".source = ./files/lxqt/lxqt.conf;
  } // nvimHomeFiles;

  home.packages = [
    codexPackage
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
    pkgs.firefox
    pkgs.slack
    pkgs.spotify
    pkgs.nodejs_24
    pkgs.fish
    pkgs.wezterm
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
    pkgs.nil
    pkgs.nixd
    pkgs.pyright
    pkgs.xclip
    pkgs.cmake
    pkgs.gcc
    pkgs.gnumake
    pkgs.gettext
    pkgs.unzip
    pkgs.universal-ctags
  ];

  home.activation.patchCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config_file="${config.home.homeDirectory}/.codex/config.toml"
    if [ -f "$config_file" ] && ! ${pkgs.gnugrep}/bin/grep -q '^model_instructions_file[[:space:]]*=' "$config_file"; then
      tmp_file="$(${pkgs.coreutils}/bin/mktemp)"
      ${pkgs.gawk}/bin/awk -v line='model_instructions_file = "~/.codex/custom_instructions.md"' '
        BEGIN { inserted = 0 }
        inserted == 0 && /^\[/ { print line; inserted = 1 }
        { print }
        END { if (inserted == 0) print line }
      ' "$config_file" > "$tmp_file"
      ${pkgs.coreutils}/bin/mv "$tmp_file" "$config_file"
    fi
  '';

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
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      update = "nix flake update ~/nixos-config && sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      cleanup = "sudo nix-collect-garbage -d";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      update = "nix flake update ~/nixos-config && sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      cleanup = "sudo nix-collect-garbage -d";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
