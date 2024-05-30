{
  pkgs,
  config,
  ...
}: {
  programs = {
    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      loginExtra = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          exec sway
        fi
      '';

      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';

      initExtra = ''
          source ~/.p10k.zsh

        #   precmd() {
        #       print -Pn "\e]133;A\e\\"
        #   }
        #   # precmd () {print -Pn "\e]0;\a"}


          # this makes opening a terminal window in current directory work
          function osc7-pwd() {
              emulate -L zsh # also sets localoptions for us
              setopt extendedglob
              local LC_ALL=C
              printf '\e]7;file://%s%s\e\' $HOST ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
          }

          function chpwd-osc7-pwd() {
              (( ZSH_SUBSHELL )) || osc7-pwd
          }
          add-zsh-hook -Uz chpwd chpwd-osc7-pwd
      '';

      defaultKeymap = "emacs";

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };

      shellAliases = {
        ll = "ls -l";
      };

      sessionVariables = {
        EDITOR = "vim";
      };

      # TODO: this causes a 2 second delay
      # plugins = [
      #         {
      #     name = "zsh-nix-shell";
      #     file = "nix-shell.plugin.zsh";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "chisui";
      #       repo = "zsh-nix-shell";
      #       rev = "v0.8.0";
      #       sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      #     };
      #   }
      # ];
    };
  };
}
