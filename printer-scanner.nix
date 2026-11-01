#printer-scanner.nix

{ config, pkgs, lib, ... }:

{
  services.printing.enable = true;
  services.printing.browsing = true;
  programs.system-config-printer.enable = true;
  services.system-config-printer.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    epson-escpr2
    epson-escpr
  ];
  hardware.sane.enable = true;
  services.ipp-usb.enable = true;
}
