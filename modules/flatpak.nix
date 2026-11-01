{ pkgs, ... }:

{
  services.flatpak.enable = true;

  systemd.user.services.flatpak-user-repo = {
    description = "Add Flathub remote for user";
    wantedBy = [ "default.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  systemd.user.services.flatpak-user-update = {
    description = "Update user Flatpaks";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = "flatpak update --user --noninteractive --assumeyes || true";
  };
  systemd.user.timers.flatpak-user-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
