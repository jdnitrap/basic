#flatpak.nix

{ config, lib, pkgs, inputs, ... }:

{
  services.flatpak.enable = true;

  # Per-user Flathub for normal installs.
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

  # System Flathub. Only an admin may install or update it.
  systemd.services.flatpak-system-repo = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # AUTH_ADMIN_KEEP asks once and remembers it for the rest of the update.
  # AUTH_ADMIN asked again for every app and runtime.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.Flatpak.") == 0) {
        if (subject.isInGroup("wheel")) {
          return polkit.Result.AUTH_ADMIN_KEEP;
        }
        return polkit.Result.NO;
      }
    });
  '';
}
