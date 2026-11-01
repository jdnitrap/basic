#networking.nix

{ config, pkgs, lib, ... }:

{
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  services.openssh.enable = false;
  networking.firewall.enable = true;
  networking.firewall.checkReversePath = false;
}
