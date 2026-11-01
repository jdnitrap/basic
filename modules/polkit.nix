{ ... }:

{
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.Flatpak.") == 0) {
        if (action.id == "org.freedesktop.Flatpak.app-update" ||
            action.id == "org.freedesktop.Flatpak.runtime-update") {
          return polkit.Result.YES;
        }
        if (subject.isInGroup("wheel")) {
          return polkit.Result.AUTH_ADMIN_KEEP;
        }
        return polkit.Result.NO;
      }
      if (action.id == "org.freedesktop.accounts.user-administration" &&
          subject.active && subject.local && subject.isInGroup("wheel")) {
        return polkit.Result.AUTH_ADMIN_KEEP;
      }
    });
  '';
}
