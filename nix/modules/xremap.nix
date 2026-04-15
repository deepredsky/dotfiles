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
    exact_match = true;
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
      "C-k" = [ "Shift-end" "Delete" ];
      "C-u" = [ "Shift-home" "Delete" ];

      "C-Shift-a" = "Shift-home";
      "C-Shift-e" = "Shift-end";

      "C-w" = "C-Backspace";
    };
    application.not = [
      "kitty"
      "vim"
      "foot"
      "ghostty"
      "emacs"
      "neovim"
    ];
  }

  {
    name = "Cmd shortcuts in GUI apps except Firefox";
    exact_match = true;
    remap = {
      "Super-c" = "C-c";
      "Super-v" = "C-v";
      "Super-x" = "C-x";
      "Super-a" = "C-a";
      "Super-z" = "C-z";
      "Super-y" = "C-y";
      "Super-s" = "C-s";
    };
    application.not = [
      "firefox"
      "kitty"
      "foot"
      "ghostty"
      "alacritty"
      "wezterm"
      "emacs"
      "neovim"
      "vim"
    ];
  }

  {
    name = "Cmd copy paste in terminals";
    exact_match = true;
    remap = {
      "Super-c" = "C-Shift-c";
      "Super-v" = "C-Shift-v";
    };
    application.only = [
      "kitty"
      "foot"
      "ghostty"
      "alacritty"
      "wezterm"
    ];
  }
];
  };
}
