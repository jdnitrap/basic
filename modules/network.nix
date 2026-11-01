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
    rules.adguard-dns = {
      name = "adguard-dns";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "simple";
            operand = "process.path";
            sensitive = false;
            data = "${pkgs.adguardhome}/bin/AdGuardHome";
          }
          {
            type = "regexp";
            operand = "dest.port";
            sensitive = false;
            data = "^(53|443)$";
          }
        ];
      };
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
        bind_hosts = [ "127.0.0.1" "::1" ];
        port = 53;
        upstream_dns = [
          "https://dns.quad9.net/dns-query"
        ];
        fallback_dns = [
          "https://dns.cloudflare.com/dns-query"
        ];
        bootstrap_dns = [
          "9.9.9.9"
          "1.1.1.1"
        ];
      };
      querylog = {
        enabled = true;
        interval = "1d";
        file_enabled = true;
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
          id = 1;
          name = "AdGuard DNS filter";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
        }
        {
          enabled = true;
          id = 2;
          name = "AdGuard DNS popup filter";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
        }
        {
          enabled = true;
          id = 3;
          name = "Malicious URL Blocklist (URLHaus)";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
        }
        {
          enabled = true;
          id = 4;
          name = "Dandelion Sprout's Anti-Malware List";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt";
        }
        {
          enabled = true;
          id = 5;
          name = "Phishing URL Blocklist (PhishTank and OpenPhish)";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt";
        }
        {
          enabled = true;
          id = 6;
          name = "NoCoin Filter List";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt";
        }
      ];
    };
  };
  networking.nameservers = [ "127.0.0.1" "::1" ];
  networking.networkmanager.dns = "none";

  # Keep browser lookups on AdGuard. Built-in DNS-over-HTTPS would skip it.
  programs.firefox = {
    enable = true;
    policies.DNSOverHTTPS = {
      Enabled = false;
      Locked = true;
    };
  };
  programs.chromium = {
    enable = true;
    extraOpts = {
      DnsOverHttpsMode = "off";
      BuiltInDnsClientEnabled = false;
    };
  };

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
