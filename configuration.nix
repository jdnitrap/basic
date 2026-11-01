#configuration.nix

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "Asus";

  # Hardware support
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  # Locale and time
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
  time.timeZone = "America/New_York";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  documentation.nixos.enable = false;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.gvfs.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };
  xdg.terminal-exec.enable = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  services.openssh.enable = false;

  # Firewall (firewalld + Plasma panel)
  networking.nftables.enable = true;
  services.firewalld.enable = true;
  networking.firewall.enable = false;

  # AdGuard Home
  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    port = 3000;
    mutableSettings = true;
    settings = {
      dns = {
        bind_hosts = [ "127.0.0.1" ];
        port = 53;
        upstream_dns = [
          "https://dns.quad9.net/dns-query"
          "https://dns.cloudflare.com/dns-query"
        ];
        bootstrap_dns = [
          "9.9.9.9"
          "1.1.1.1"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search.enabled = false;
      };
      filters = [
        {
          enabled = true;
          name = "AdGuard DNS filter";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
        }
        {
          enabled = true;
          name = "AdGuard DNS popup filter";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
        }
      ];
    };
  };
  networking.nameservers = [ "127.0.0.1" ];
  networking.networkmanager.dns = "none";

  # AdGuard desktop entry
  environment.etc."xdg/applications/adguard-home.desktop".text = ''
    [Desktop Entry]
    Name=AdGuard Home
    Comment=Local DNS ad blocker dashboard
    Exec=xdg-open http://127.0.0.1:3000
    Icon=preferences-system-network
    Terminal=false
    Type=Application
    Categories=Network;Security;
  '';

  # Printing and scanning
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
    epson-escpr2
    epson-escpr
  ];
  hardware.sane.enable = true;
  services.ipp-usb.enable = true;

  # Users
  users.mutableUsers = true;
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };
  services.accounts-daemon.enable = true;

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    gh
    flatpak
    wireguard-tools

    # KDE / Plasma applications (stable channel)
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
    kdePackages.plasma-firewall
    kdePackages.falkon
    kdePackages.kdeconnect-kde
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
    kdePackages.umbrello
    kdePackages.ktorrent
    kdePackages.ktouch
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
    kdePackages.kphotoalbum
  ];

  # Flatpak
  services.flatpak.enable = true;

  # System Flathub + extra KDE apps
  systemd.services.flatpak-system-setup = {
    description = "Add Flathub and install system KDE Flatpaks";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      flatpak install --system --noninteractive --assumeyes \
        org.kde.kleopatra \
        org.kde.kmymoney \
        org.kde.krename \
        org.kde.qrca \
        org.kde.kalzium \
        org.kde.kaffeine \
        org.kde.subtitlecomposer \
        org.kde.kid3 \
        org.kde.kstars \
        org.kde.kweather \
        org.kde.minuet \
        org.kde.gcompris \
        org.kde.crowtranslate \
        org.kde.kdiskfree || true
    '';
  };

  systemd.user.services.flatpak-user-repo = {
    description = "Add Flathub remote for user";
    wantedBy = [ "default.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  systemd.user.services.flatpak-user-update = {
    description = "Update user Flatpaks";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = "flatpak update --user --noninteractive --assumeyes || true";
  };
  systemd.user.timers.flatpak-user-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.Flatpak.") == 0) {
        if (action.id == "org.freedesktop.Flatpak.app-update" ||
            action.id == "org.freedesktop.Flatpak.runtime-update") {
          return polkit.Result.YES;
        }
        if (subject.isInGroup("wheel")) {
          return polkit.Result.AUTH_ADMIN_KEEP;
        }
        return polkit.Result.NO;
      }
      if (action.id == "org.freedesktop.accounts.user-administration" &&
          subject.active && subject.local) {
        return polkit.Result.YES;
      }
    });
  '';

  # Auto update at 7 PM
  system.autoUpgrade = {
    enable = true;
    persistent = true;
    dates = "19:00";
    randomizedDelaySec = "0";
    allowReboot = false;
    flags = [
      "--upgrade"
      "--option" "build-cores" "1"
      "--option" "cores" "1"
    ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  systemd.services.nixos-upgrade = {
    path = [ pkgs.libnotify pkgs.sudo pkgs.coreutils ];
    serviceConfig = {
      Nice = 19;
      IOSchedulingClass = "idle";
      CPUSchedulingPolicy = "idle";
    };
    postStart = ''
      for uid in $(ls /run/user 2>/dev/null || true); do
        [ -S "/run/user/$uid/bus" ] || continue
        user=$(id -nu "$uid" 2>/dev/null || true)
        [ -n "$user" ] || continue
        sudo -u "$user" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
          notify-send "NixOS update" "The 7 PM system update finished." || true
      done
    '';
  };

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Laptop
  services.fstrim.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;
  nix.optimise.automatic = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
  };

  # AppArmor
  security.apparmor.enable = true;
  security.apparmor.killUnconfinedConfinables = false;

  # State version
  system.stateVersion = "26.05";
}
