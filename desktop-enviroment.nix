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
    gnome-extensions-app
  ];

  # The Extensions launcher is inside gnome-shell, so it cannot be uninstalled.
  # A higher-priority desktop file hides the icon.
  environment.systemPackages = [
    (lib.hiPrio (pkgs.runCommand "hide-gnome-extensions-app" { } ''
      install -Dm644 /dev/stdin $out/share/applications/org.gnome.Shell.Extensions.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=Extensions
      NoDisplay=true
      Hidden=true
      EOF
      install -Dm644 /dev/stdin $out/share/applications/org.gnome.Extensions.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=Extensions
      NoDisplay=true
      Hidden=true
      EOF
    ''))
  ];
}
