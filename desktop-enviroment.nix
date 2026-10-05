#desktop_enviroment.nix

{ config, pkgs, lib, ... }:

let
  hiddenDesktop = name: pkgs.writeText name ''
    [Desktop Entry]
    Type=Application
    Name=Extensions
    NoDisplay=true
    Hidden=true
  '';
  hideExtensions = lib.hiPrio (pkgs.runCommand "hide-gnome-extensions-app" { } ''
    install -Dm644 ${hiddenDesktop "org.gnome.Shell.Extensions.desktop"} \
      $out/share/applications/org.gnome.Shell.Extensions.desktop
    install -Dm644 ${hiddenDesktop "org.gnome.Extensions.desktop"} \
      $out/share/applications/org.gnome.Extensions.desktop
  '');
in
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
    gnome-shell-extensions
  ];

  environment.systemPackages = [ hideExtensions ];

  system.activationScripts.hideGnomeExtensions.text = ''
    for home in /home/*; do
      [ -d "$home" ] || continue
      dir="$home/.local/share/applications"
      mkdir -p "$dir"
      cp -f ${hiddenDesktop "org.gnome.Shell.Extensions.desktop"} "$dir/org.gnome.Shell.Extensions.desktop"
      cp -f ${hiddenDesktop "org.gnome.Extensions.desktop"} "$dir/org.gnome.Extensions.desktop"
      chown --reference="$home" "$dir" "$dir"/*.desktop
    done
  '';
}
