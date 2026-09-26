{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;

    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
      {
        timeout = 600;
        command = "niri msg action power-off-monitors";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
    ];
  };
}
