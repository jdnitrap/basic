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
	./gnome.nix
	./cinnamon.nix
	./boot.nix
	./networking.nix
	./user-accounts.nix
	./flatpak.nix
	./auto-update.nix
	./experimental-features.nix
	./laptop.nix
	./apparmor.nix
	./auto-login.nix

    ];

  networking.hostName = "Asus";

  # GNOME and Cinnamon both set this. One shared path lets both stay installed.
  environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = lib.mkForce (
    config.environment.etc."xdg/nix-overrides/glib-2.0/schemas".source
  );

}
