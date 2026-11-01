#configuration.nix

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/locale.nix
    ./modules/hardware.nix
    ./modules/desktop.nix
    ./modules/network.nix
    ./modules/printing.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/flatpak.nix
    ./modules/polkit.nix
    ./modules/maintenance.nix
    ./modules/apparmor.nix
  ];

  networking.hostName = "Asus";

  # State version
  system.stateVersion = "26.05";
}
