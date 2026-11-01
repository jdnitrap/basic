{ pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  services.openssh.enable = false;

  networking.nftables.enable = true;
  networking.firewall.enable = true;
  programs.kdeconnect.enable = true;
  services.opensnitch = {
    enable = true;
    settings = {
      InterceptUnknown = true;
      DefaultAction = "deny";
    };
  };

  environment.etc."xdg/autostart/opensnitch-ui.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=OpenSnitch
    Comment=Application firewall prompts
    Exec=${pkgs.opensnitch-ui}/bin/opensnitch-ui
    Terminal=false
    Categories=System;Security;
    X-GNOME-Autostart-enabled=true
  '';

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

  environment.systemPackages = [
    (pkgs.makeDesktopItem {
      name = "adguard-home";
      desktopName = "AdGuard Home";
      comment = "Local DNS ad blocker dashboard";
      exec = "${pkgs.xdg-utils}/bin/xdg-open http://127.0.0.1:3000";
      icon = "preferences-system-network";
      categories = [ "Network" "Security" ];
    })
  ];
}
