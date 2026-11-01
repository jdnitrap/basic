#configuration.nix

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware-support.nix
    ./boot.nix
    ./locale.nix
    ./sound.nix
    ./plasma.nix
    ./networking.nix
    ./adguard.nix
    ./printer-scanner.nix
    ./users.nix
    ./packages.nix
    ./flatpak.nix
    ./auto-update.nix
    ./experimental-features.nix
    ./laptop.nix
    ./apparmor.nix
  ];

  networking.hostName = "Asus";
  system.stateVersion = "26.05";
}
