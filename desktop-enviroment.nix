#desktop_enviroment.nix

{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # Extensions is built into gnome-shell. A user desktop file overrides its icon.
  system.activationScripts.hideGnomeExtensions.text = ''
    for home in /home/*; do
      [ -d "$home" ] || continue
      dir="$home/.local/share/applications"
      mkdir -p "$dir"
      cat > "$dir/org.gnome.Shell.Extensions.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Extensions
NoDisplay=true
Hidden=true
EOF
      chown --reference="$home" "$dir/org.gnome.Shell.Extensions.desktop"
      chown --reference="$home" "$dir"
    done
  '';
}
