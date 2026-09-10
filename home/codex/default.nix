{ config, lib, pkgs, ... }:

{
  home.file.".codex/custom_instructions.md".source = ./custom_instructions.md;
  home.file.".codex/openrouter-deepseek.config.toml".source = ./openrouter-deepseek.config.toml;
  home.file.".local/bin/codex-deepseek" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      exec codex --profile openrouter-deepseek "$@"
    '';
  };
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
