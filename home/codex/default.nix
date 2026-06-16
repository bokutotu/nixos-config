{ config, lib, pkgs, ... }:

{
  home.file.".codex/custom_instructions.md".source = ./custom_instructions.md;
  home.file.".codex/agents" = {
    source = ./agents;
    recursive = true;
  };
  home.file.".codex/skills/development".source = ./skills/development;

  home.activation.patchCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config_file="${config.home.homeDirectory}/.codex/config.toml"
    config_dir="$(${pkgs.coreutils}/bin/dirname "$config_file")"
    ${pkgs.coreutils}/bin/mkdir -p "$config_dir"
    ${pkgs.coreutils}/bin/touch "$config_file"

    if ! ${pkgs.gnugrep}/bin/grep -q '^model_instructions_file[[:space:]]*=' "$config_file"; then
      tmp_file="$(${pkgs.coreutils}/bin/mktemp)"
      ${pkgs.gawk}/bin/awk -v line='model_instructions_file = "~/.codex/custom_instructions.md"' '
        BEGIN { inserted = 0 }
        inserted == 0 && /^\[/ { print line; inserted = 1 }
        { print }
        END { if (inserted == 0) print line }
      ' "$config_file" > "$tmp_file"
      ${pkgs.coreutils}/bin/mv "$tmp_file" "$config_file"
    fi

    tmp_file="$(${pkgs.coreutils}/bin/mktemp)"
    ${pkgs.gawk}/bin/awk '
      function flush_agents() {
        if (in_agents) {
          if (!seen_threads) print "max_threads = 6"
          if (!seen_depth) print "max_depth = 1"
          in_agents = 0
        }
      }
      BEGIN {
        in_agents = 0
        seen_agents = 0
        seen_threads = 0
        seen_depth = 0
      }
      /^[[:space:]]*\[agents\][[:space:]]*$/ {
        flush_agents()
        print
        in_agents = 1
        seen_agents = 1
        seen_threads = 0
        seen_depth = 0
        next
      }
      /^[[:space:]]*\[/ {
        flush_agents()
        print
        next
      }
      in_agents && /^[[:space:]]*max_threads[[:space:]]*=/ {
        if (!seen_threads) print "max_threads = 6"
        seen_threads = 1
        next
      }
      in_agents && /^[[:space:]]*max_depth[[:space:]]*=/ {
        if (!seen_depth) print "max_depth = 1"
        seen_depth = 1
        next
      }
      { print }
      END {
        flush_agents()
        if (!seen_agents) {
          if (NR > 0) print ""
          print "[agents]"
          print "max_threads = 6"
          print "max_depth = 1"
        }
      }
    ' "$config_file" > "$tmp_file"
    ${pkgs.coreutils}/bin/mv "$tmp_file" "$config_file"
  '';
}
