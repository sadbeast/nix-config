{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    # ./firefox.nix
    ./foot.nix
    ./qutebrowser.nix
    ./sway.nix
    ./waybar.nix
  ];

  home = {
    packages = with pkgs; [
      galculator
      pavucontrol
      vlc
      waypipe
      wine
    ];
  };
}