{ pkgs, config, ... }:
let
  lockCommand = "${config.programs.swaylock.package}/bin/swaylock";
in
{
  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;

    timeouts = [
      {
        timeout = 300;
        command = lockCommand;
      }
      {
        timeout = 600;
        command = "niri msg action power-off-monitors";
      }
    ];

    events = {
      before-sleep = lockCommand;
    };
  };
}
