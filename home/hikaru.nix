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

  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 42;

    x11.enable = true;
    gtk.enable = true;
  };

  home.sessionPath = [
    "${codexPackage}/bin"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  home.file = {
    ".npmrc".text = ''
prefix=${config.home.homeDirectory}/.npm-global
'';
    ".config/fish/config.fish".text = (builtins.readFile ./files/fish/config.fish) + ''

if status --is-login; and test -z "$DISPLAY"; and test "$XDG_VTNR" = 1
    set -gx XDG_CURRENT_DESKTOP i3
    set -gx XDG_SESSION_TYPE x11
    set -gx GTK_IM_MODULE fcitx
    set -gx QT_IM_MODULE fcitx
    set -gx XMODIFIERS @im=fcitx

    exec startx
end
'';
    ".tmux.conf".source = ./files/tmux/tmux.conf;
    ".config/alacritty/alacritty.toml".source = ./files/alacritty/alacritty.toml;
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
    ".local/bin/i3-window-switcher" = {
      source = ./files/bin/i3-window-switcher;
      executable = true;
    };
    ".config/i3/config".text = ''
set $mod Mod4
set $term alacritty
set $menu dmenu_run

font pango:JetBrainsMono Nerd Font 10

exec --no-startup-id dunst
exec fcitx5 -d

bindsym $mod+Return exec $term
bindsym $mod+d exec $menu
bindsym $mod+Tab exec --no-startup-id ${config.home.homeDirectory}/.local/bin/i3-window-switcher
bindsym F11 fullscreen toggle
bindsym $mod+l exec i3lock -c 000000
bindsym Print exec maim -s | xclip -selection clipboard -t image/png
bindsym Shift+Print exec maim | xclip -selection clipboard -t image/png
bindsym $mod+Shift+q kill
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'

bindsym $mod+r mode "resize"

mode "resize" {
    bindsym h resize shrink width 10 px
    bindsym l resize grow width 10 px
    bindsym k resize shrink height 10 px
    bindsym j resize grow height 10 px

    bindsym Return mode "default"
    bindsym Escape mode "default"
}

bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+5 workspace number 5
bindsym $mod+6 workspace number 6
bindsym $mod+7 workspace number 7
bindsym $mod+8 workspace number 8
bindsym $mod+9 workspace number 9
bindsym $mod+0 workspace number 10
bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5
bindsym $mod+Shift+6 move container to workspace number 6
bindsym $mod+Shift+7 move container to workspace number 7
bindsym $mod+Shift+8 move container to workspace number 8
bindsym $mod+Shift+9 move container to workspace number 9
bindsym $mod+Shift+0 move container to workspace number 10

floating_modifier $mod

bar {
    status_command i3status
}
'';
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
    pkgs.alacritty
    pkgs.dmenu
    pkgs.dunst
    pkgs.i3status
    pkgs.i3lock
    pkgs.maim
    pkgs.slop
    pkgs.xclip
    pkgs.xorg.xrandr
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
