#hardware-support.nix

{ config, pkgs, lib, ... }:

{
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
