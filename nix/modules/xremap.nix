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
          "C-h" = "Backspace";
          "C-a" = "home";
          "C-e" = "end";
          "C-Shift-a" = "Shift-home";
          "C-Shift-e" = "Shift-end";
          "C-w" = "C-Backspace";
        };
        application.not = [
          "kitty"
          "vim"
        ];
      }
    ];
  };
}
