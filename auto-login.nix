#auto-login.nix
# GNOME only enables Automatic Login for administrator accounts.
# On NixOS that means the wheel group.

{ config, pkgs, lib, ... }:

{
  services.accounts-daemon.enable = true;
  users.mutableUsers = true;

  # Do not set services.displayManager.autoLogin. That would lock the switch.

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.accounts.user-administration" &&
          subject.active && subject.local) {
        return polkit.Result.YES;
      }
    });
  '';

  # GNOME hides the switch on standard accounts. Put local users in wheel.
  system.activationScripts.localUsersAreAdmins.text = ''
    ${pkgs.shadow}/bin/getent passwd | ${pkgs.gawk}/bin/awk -F: '$3 >= 1000 && $3 < 65534 { print $1 }' |
      while read -r user; do
        ${pkgs.shadow}/bin/usermod -aG wheel "$user" || true
      done
  '';
}
