{
  inputs,
  outputs,
  ...
}: {
  programs.foot = {
    enable = true;

    # server.enable = true;

    settings = {
      main = {
        font = "Iosevka-11:style=Medium,Regular, JoyPixels";
        font-bold = "Iosevka-11:style=Bold";
        font-italic = "Iosevka-11:style=Italic";

        underline-offset = 1;
      };
    };
  };
}
