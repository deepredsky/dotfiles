{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.xremap-flake.nixosModules.default
  ];

  services.xremap = {
    enable = true;
    serviceMode = "user";
    userName = "rajesh";
    withWlroots = true;

    config.modmap = [
      {
        name = "Global";
        remap = { "CapsLock" = "Esc"; };
      }
    ];

    config.keymap = [
      {
        name = "Emacs binding in input elements";
        remap = {
          "C-b" = "Left";
          "C-f" = "Right";
          "C-p" = "Up";
          "C-n" = "Down";

          "M-b" = "Ctrl-Left";
          "M-f" = "Ctrl-Right";

          "C-h" = "Backspace";
          "C-a" = "home";
          "C-e" = "end";
          "C-k" = ["Shift-end" "Delete"];
          "C-u" = ["Shift-home" "Delete"];

          "C-Shift-a" = "Shift-home";
          "C-Shift-e" = "Shift-end";

          "C-w" = "C-Backspace";
        };
        application.not = [
          "kitty"
          "vim"
          "foot"
        ];
      }
    ];
  };
}
