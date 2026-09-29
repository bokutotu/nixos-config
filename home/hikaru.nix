{ ... }:

{
  imports = [ ./dev-shell.nix ];

  home.username = "hikaru";
  home.homeDirectory = "/home/hikaru";
  home.stateVersion = "25.11";
}
