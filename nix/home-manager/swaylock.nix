{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      fade-in = 0.2;

      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      indicator-caps-lock = true;

      font = "sans-serif";
      font-size = 32;

      # Catppuccin Mocha, matching the GTK theme
      ring-color = "1e1e2e";
      ring-clear-color = "f9e2af";
      ring-caps-lock-color = "fab387";
      ring-ver-color = "89b4fa";
      ring-wrong-color = "f38ba8";

      inside-color = "1e1e2ecc";
      inside-clear-color = "1e1e2ecc";
      inside-caps-lock-color = "1e1e2ecc";
      inside-ver-color = "1e1e2ecc";
      inside-wrong-color = "1e1e2ecc";

      key-hl-color = "a6e3a1";
      bs-hl-color = "f38ba8";

      line-color = "00000000";
      separator-color = "00000000";

      text-color = "cdd6f4";
      text-clear-color = "1e1e2e";
      text-ver-color = "1e1e2e";
      text-wrong-color = "1e1e2e";

      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "cdd6f4";
    };
  };
}
