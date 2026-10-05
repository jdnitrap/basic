#flatpak.nix

{ config, lib, pkgs, inputs, ... }:

{
  services.flatpak.enable = true;

  # User install only. Do not add a system-wide Flathub remote.
  systemd.user.services.flatpak-repo = {
    wantedBy = [ "default.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  systemd.services.flatpak-no-system-remote = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-delete --system flathub || true
    '';
  };

  # Block polkit prompts that would install or change system-wide Flatpaks.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.Flatpak.") == 0) {
        return polkit.Result.NO;
      }
    });
  '';
}
