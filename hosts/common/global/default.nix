# This holds configuration common across hosts
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    ./sops.nix
  ];

  #home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      # outputs.overlays.modifications

      outputs.overlays.stable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes ca-derivations";
      accept-flake-config = true;
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nixpkgs-ruby.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-ruby.cachix.org-1:vrcdi50fTolOxWCZZkw0jakOnUI1T19oYJ+PRYdK4SM="
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "emacs2";
  };

  programs = {
    sway.enable = true;
    zsh.enable = true;
    # zsh.promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    git.enable = true;

    fuse.userAllowOther = true;
  };

  users.mutableUsers = false;

  users.users.sadbeast = {
    hashedPasswordFile = config.sops.secrets.sadbeast-password.path;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGpEusv/bS34Q1JQxZXikdcwnq1vToz2d+HgV+E8NRX"
    ];

    extraGroups = ["wheel" "audio" "video"];
    shell = pkgs.zsh;
    packages = [pkgs.home-manager];
  };

  sops.secrets.sadbeast-password = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.sadbeast = import ../../../home/sadbeast/${config.networking.hostName}.nix;

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    openssh = {
      enable = true;
      settings = {
        # Opinionated: forbid root login through SSH.
        PermitRootLogin = "no";
        # Opinionated: use keys only.
        PasswordAuthentication = false;
        X11Forwarding = true;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing.enable = true;
  };

  security = {
    polkit.enable = true;
    # rtkit is optional but recommended
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;

    pam.services = {
      swaylock = {};
    };
  };

  # environment.persistence."/persistent" = {
  #   hideMounts = true;
  #   directories = [
  #     "/var/log"
  #     "/var/lib/nixos"
  #     "/var/lib/systemd"
  #   ];
  #   files = [
  #     "/etc/machine-id"
  #     "/var/lib/sops-nix/keys.txt"
  #   ];
  # };

  # system.activationScripts.persistent-dirs.text = let
  #   mkHomePersist = user:
  #     lib.optionalString user.createHome ''
  #       mkdir -p /persistent/${user.home}
  #       chown ${user.name}:${user.group} /persistent/${user.home}
  #       chmod ${user.homeMode} /persistent/${user.home}
  #     '';
  #   users = lib.attrValues config.users.users;
  # in
  #   lib.concatLines (map mkHomePersist users);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
