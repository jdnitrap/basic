#auto-update.nix

{ config, pkgs, lib, ... }:

{
  system.autoUpgrade = {
    enable = true;
    persistent = true;
    dates = "15:00";
    randomizedDelaySec = "0";
    allowReboot = false;
    flake = "github:jdnitrap/basic";
    flags = [
      "--refresh"
      "--option" "build-cores" "1"
      "--option" "cores" "1"
    ];
  };

  systemd.services.nixos-upgrade = {
    path = [ pkgs.libnotify pkgs.sudo ];
    serviceConfig = {
      Nice = 19;
      IOSchedulingClass = "idle";
      CPUSchedulingPolicy = "idle";
    };
    postStart = ''
      uid=$(id -u nimda 2>/dev/null || true)
      if [ -n "$uid" ] && [ -S "/run/user/$uid/bus" ]; then
        sudo -u nimda DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
          notify-send "NixOS update" "The 3 PM system update finished." || true
      fi
    '';
  };
}
