#boot.nix

{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  boot.plymouth.enable = true;
  boot.plymouth.theme = "circuit";
  boot.plymouth.themePackages = [
    (pkgs.adi1090x-plymouth-themes.override {
      selected_themes = [ "circuit" ];
    })
  ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];
}
