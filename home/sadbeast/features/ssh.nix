{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "falken" = {
        hostname = "sadbeast.com";
        port = 6973;
      };

      "crystalpalace" = {
        hostname = "192.168.0.2";
        port = 6973;
      };

      "joshua" = {
        hostname = "192.168.0.3";
      };

      "teamdraft" = {
        hostname = "teamdraft.net";
        port = 6973;
      };
    };
  };
}
