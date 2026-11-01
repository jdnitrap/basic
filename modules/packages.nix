{ pkgs, ... }:

{
  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    gh
    git-lfs
    flatpak
    wireguard-tools
    opensnitch-ui
    ollama
    llama-cpp
    python3
    obsidian

    # Browsers
    firefox
    brave

    # Office
    libreoffice

    # CAD
    freecad
    librecad

    # Security
    #lynis
    #aide
    #firejail

    # Proton
    proton-vpn
    proton-pass
    proton-vpn-cli
    protonmail-desktop
    proton-authenticator

    # KDE / Plasma applications
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kate
    kdePackages.konsole
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.elisa
    kdePackages.kcalc
    kdePackages.filelight
    kdePackages.partitionmanager
    kdePackages.kdenlive
    kdePackages.kmail
    kdePackages.kontact
    kdePackages.korganizer
    kdePackages.discover
    kdePackages.plasma-systemmonitor
    kdePackages.kinfocenter
    kdePackages.systemsettings
    kdePackages.khelpcenter
    kdePackages.plasma-browser-integration
    kdePackages.kcharselect
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.kclock
    kdePackages.kcolorchooser
    kdePackages.yakuake
    kdePackages.kfind
    kdePackages.isoimagewriter
    kdePackages.falkon
    kdePackages.k3b
    kdePackages.juk
    kdePackages.dragon
    kdePackages.ghostwriter
    kdePackages.kasts
    kdePackages.kamoso
    kdePackages.calligra
    kdePackages.kdevelop
    kdePackages.kcachegrind
    kdePackages.kcron
    kdePackages.kdf
    kdePackages.kbackup
    kdePackages.kalarm
    kdePackages.kaddressbook
    kdePackages.akregator
    kdePackages.audex
    kdePackages.kde-dev-utils
    kdePackages.kde-dev-scripts
    kdePackages.kdialog
    kdePackages.plasma-vault
    kdePackages.print-manager
    kdePackages.kup
    kdePackages.flatpak-kcm
    kdePackages.kde-gtk-config
    kdePackages.sddm-kcm
    kdePackages.powerdevil
    kdePackages.milou
    kdePackages.ksshaskpass
    kdePackages.kwallet-pam
    kdePackages.drkonqi
    kdePackages.kio-fuse
    kdePackages.phonon-vlc
    kdePackages.kirigami-addons
    kdePackages.kgpg
    kdePackages.kget
    kdePackages.sweeper
    kdePackages.skanlite
    kdePackages.skanpage
    kdePackages.konqueror
    kdePackages.kdenetwork-filesharing
    kdePackages.kwalletmanager
    kdePackages.kgeography
    kdePackages.kwordquiz
    kdePackages.kanagram
    kdePackages.khangman
    kdePackages.kig
    kdePackages.kalgebra
    kdePackages.kbruch
    kdePackages.marble
  ];
}
