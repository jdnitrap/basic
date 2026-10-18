#cinnamon.nix

{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.displayManager.lightdm.enable = true;
  services.desktopManager.cinnamon.enable = true;

  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.cinnamon = {
      default = [ "gtk" ];
    };
  };

  xdg.terminal-exec.enable = true;
}
