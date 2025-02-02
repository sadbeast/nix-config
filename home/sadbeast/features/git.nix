{
  config,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = lib.mkDefault config.home.username;
    userEmail = lib.mkDefault "sadbeast@sadbeast.com";

    aliases = {
      p = "pull --ff-only";
      ff = "merge --ff-only";
      graph = "log --decorate --oneline --graph";
      add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
      # for "last branch", shows the most recently accessed branches
      lb = "!git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 15 | awk -F' ~ HEAD@{' '{printf(\"  \\033[33m%s: \\033[37m %s\\033[0m\\n\", substr($2, 1, length($2)-1), $1)}'";
    };

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      # Reuse merge conflict fixes when rebasing
      rerere.enabled = true;
    };
    ignores = [".direnv"];

    lfs.enable = true;
  };
}
