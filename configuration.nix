#configuration.nix

{ config, pkgs, lib, ... }:

{

##############  
#Module Setup#
##############

imports =
    [

	./hardware-configuration.nix
	./hardware-support.nix
	./printer-scanner.nix
	./system-setup.nix
	./sound.nix
	./state-version.nix
	./system-packages.nix
	./plasma6.nix
	./boot.nix
	./networking.nix
	./user-accounts.nix
	./flatpak.nix
	./auto-update.nix
	./experimental-features.nix
	./laptop.nix
	./apparmor.nix
	./auto-login.nix
	./adguard.nix

    ];

  networking.hostName = "Asus";

  # Plasma is the only session.
  services.displayManager.defaultSession = "plasma";

}
