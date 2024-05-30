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

  home = {
    packages = with pkgs; [
      adrs
      aws-sam-cli
      awscli2
      gcc
      glow
      google-chrome
      libreoffice
      nodejs
      ngrok
      pgcli
      ruby
      ruby-lsp
      slack
      ssm-session-manager-plugin
      zoom
    ];
  };

  programs = {
    git = {
      userName = "Kent Smith";
      userEmail = "kent.smith@andros.co";

      extraConfig = {
        core.sshCommand = "ssh -i ~/.ssh/id_rsa -o IdentitiesOnly=yes";
      };
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

    qutebrowser = {
      settings.content.blocking.whitelist = [
        "app.bugsnag.com"
      ];
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "google-chrome.desktop";
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "x-scheme-handler/about" = "google-chrome.desktop";
    "x-scheme-handler/unknown" = "google-chrome.desktop";
  };

  wayland.windowManager.sway.config.output = {
    eDP-1 = {
      resolution = "1920x1080";
      position = "0,0";
    };
    HDMI-A-1 = {
      resolution = "1920x1080";
      position = "0,1080";
    };
    DP-1 = {
      resolution = "1920x1080";
      position = "1920,1080";
    };
  };
}
