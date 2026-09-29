{ profiles, ... }:

{
  imports = [
    profiles.dev-shell
    profiles.nvidia
  ];

  services.openssh.enable = true;
}
