# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

###################################################################
#                 Channel Version								  #
# When adding a new channel make sure your channel you are adding #
# machtes with the channel version before upgrading system        # 
###################IMPORTANT#######################################  

system.stateVersion = "26.05"; 

########################
#End of Channel Version#
########################


##############  
#Module Setup#
##############

imports =
    [ # Include the results of the hardware scan.
	./hardware-configuration.nix
    ];

#####################
#End of Module Setup#
#####################

############
#Bootloader#
############


	boot.loader.systemd-boot.enable = true;
  	boot.loader.efi.canTouchEfiVariables = true;


###################
#End of BootLoader#
################### 


#############
#Networking # 
#############

 networking.hostName = "hostnamehere"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

 # Enable the OpenSSH daemon.
   services.openssh.enable = false;

# Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = true;


###################
#End Of Networking#
###################

##############
#System Setup#
##############

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

# Set your time zone.
  time.timeZone = "America/New_York";

# Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ADDED FOR FLAKE CONVERSION: enable the flakes CLI.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


#####################
#End of System Setup#
#####################

################################
#Decktop and Display Enviroment#
################################

services.xserver = {
  enable = true;
  displayManager.lightdm.enable = true;
  desktopManager.cinnamon.enable = true;
	};

#######################################
#End of Desktop and Display Enviroment#
#######################################

#######
#Users#
#######


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "input" "audio" "lp" "scanner" "video"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  users.users.user1 = {
    isNormalUser = true;
    description = "user1";
    extraGroups = [ "networkmanager" "scanner" "lp" "input" "audio" "video"];
    packages = with pkgs; [

    ];
  };
  

##############
#End of Users#
##############


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

 

  
  

  



###########################
#Printer and Scanner Setup#
###########################


# Enable CUPS to print documents.
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
	cups-printers
	epson-escpr2
	epson-escpr
	
	];
	
hardware.sane.enable = true; # enables support for SANE scanners
  services.ipp-usb.enable = true;
  
  
##################################
#End of Printer and Scanner Setup#
##################################

#############
#Sound Setup#
#############

# Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

####################
#End of Sound Setup#
####################


#################
#System Packages#
#################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  
  environment.systemPackages = with pkgs; [

	git
	brave
	firefox
	libreoffice
thunderbird
simple-scan

	];
########################
#End of System Packages#
########################
}
