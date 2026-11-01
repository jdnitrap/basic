#packages.nix

{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    gh
    flatpak
    wireguard-tools
    kdePackages.discover
  ];
}
