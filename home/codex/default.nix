{ config, lib, pkgs, ... }:

{
  home.file.".codex/custom_instructions.md".source = ./custom_instructions.md;
  home.file.".codex/skills/cognitive-rhythm-writing".source = ./skills/cognitive-rhythm-writing;
  home.file.".codex/skills/english-tech-writing".source = ./skills/english-tech-writing;
  home.file.".codex/skills/japanese-tech-writing".source = ./skills/japanese-tech-writing;
  home.file.".codex/skills/write-plan".source = ./skills/write-plan;
  home.file.".codex/skills/write-spec".source = ./skills/write-spec;

  home.activation.patchCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config_file="${config.home.homeDirectory}/.codex/config.toml"
    config_dir="$(${pkgs.coreutils}/bin/dirname "$config_file")"
    ${pkgs.coreutils}/bin/mkdir -p "$config_dir"
    ${pkgs.coreutils}/bin/touch "$config_file"

    tmp_file="$(${pkgs.coreutils}/bin/mktemp)"
    ${pkgs.gawk}/bin/awk -f ${./patch-config.awk} "$config_file" > "$tmp_file"
    if ${pkgs.diffutils}/bin/cmp -s "$config_file" "$tmp_file"; then
      ${pkgs.coreutils}/bin/rm "$tmp_file"
    else
      ${pkgs.coreutils}/bin/mv "$tmp_file" "$config_file"
    fi
  '';
}
