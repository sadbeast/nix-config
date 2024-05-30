{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./global
    ./features/desktop
  ];
}
