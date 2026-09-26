{ pkgs, config, ... }:
let
  # Guard against duplicate swaylock instances: swayidle can fire a stale
  # timeout burst after resuming from suspend, and without this a second
  # swaylock spawns right on top of the one you just unlocked.
  lockCommand = "${pkgs.procps}/bin/pgrep -x swaylock >/dev/null || ${config.programs.swaylock.package}/bin/swaylock";
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
