{
  pkgs,
  config,
  ...
}: {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
    package = pkgs.pass.withExtensions (p: [p.pass-otp]);
  };

  # home.persistence = {
  #   "/persistent${config.home.homeDirectory}".directories = [".password-store"];
  # };
}
