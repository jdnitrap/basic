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
    # firefox comes from programs.firefox so its DNS policy applies
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

    #Email
    thunderbird

    # Proton
    proton-vpn
    proton-pass
    proton-vpn-cli
    protonmail-desktop
    proton-authenticator

    # Plasma's default apps come from services.desktopManager.plasma6.
  ];
}
