#flatpak.nix

{ config, lib, pkgs, inputs, ... }:

{
  services.flatpak.enable = true;

  # User Flathub only. A system remote makes GNOME Software retry updates
  # and loop on the admin password prompt.
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

  systemd.services.flatpak-remove-system-remote = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-delete --system flathub || true
    '';
  };

  # A system install still needs an admin if a system remote is added later.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.Flatpak.") == 0) {
        if (subject.isInGroup("wheel")) {
          return polkit.Result.AUTH_ADMIN;
        }
        return polkit.Result.NO;
      }
    });
  '';
}
