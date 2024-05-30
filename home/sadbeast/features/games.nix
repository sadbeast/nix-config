{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
      discord
      ez80asm
      fab-agon-emulator
      fceux
      (retroarch.withCores (cores:
        with cores; [
          mesen
          gambatte
        ]))
    ];
  };

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #   localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  # };
}
