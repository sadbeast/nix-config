{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/optional/wireless.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "work";

  # Slows down write operations considerably
  nix.settings.auto-optimise-store = false;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  services = {
    logind.extraConfig = ''
      HandleLidSwitchExternalPower=ignore
    '';
    tmate-ssh-server.enable = true;

    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks # is the package manager for Lua modules
          luadbi-mysql # Database abstraction layer
        ];
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;

      daemon.settings = {
        # userland-proxy = false;
        # experimental = true;
        # metrics-addr = "0.0.0.0:9323";
        # ipv6 = true;
        # fixed-cidr-v6 = "fd00::/80";

        log-opts = {
          compress = "false";
        };
      };

      logDriver = "local";
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
      storageDriver = "btrfs";
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };
  };

  users.users.sadbeast = {
    hashedPasswordFile = config.sops.secrets.sadbeast-password.path;

    extraGroups = ["docker" "libvirtd"];

    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };

  environment = {
    systemPackages = [
      (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
          -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          "$@"
      '')
      pkgs.qemu
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
