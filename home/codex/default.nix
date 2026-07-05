{ config, lib, pkgs, ... }:

{
  home.file.".codex/custom_instructions.md".source = ./custom_instructions.md;
  home.file.".codex/skills/english-tech-writing".source = ./skills/english-tech-writing;
  home.file.".codex/skills/japanese-tech-writing".source = ./skills/japanese-tech-writing;
  home.file.".codex/skills/write-plan".source = ./skills/write-plan;
  home.file.".codex/skills/write-spec".source = ./skills/write-spec;

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
  '';
}
