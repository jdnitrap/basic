{ pkgs, ... }:

let
  avahiBin = "${pkgs.avahi}/{bin,sbin}/avahi-daemon";
  cupsdBin = "${pkgs.cups}/{bin,sbin}/cupsd";
in
{
  security.apparmor.enable = true;
  security.apparmor.killUnconfinedConfinables = false;

  # Complain logs denials and still allows the access. These profiles attach
  # to the Nix store paths, so the /usr/sbin profiles in apparmor-profiles do not.
  security.apparmor.policies."bin.avahi-daemon" = {
    state = "complain";
    profile = ''
      abi <abi/4.0>,
      include <tunables/global>

      profile avahi-daemon ${avahiBin} flags=(attach_disconnected) {
        include <abstractions/base>
        include <abstractions/consoles>
        include <abstractions/dbus>
        include <abstractions/nameservice>
        include "${pkgs.apparmorRulesFromClosure { name = "avahi-daemon"; } [ pkgs.avahi ]}"

        capability chown,
        capability dac_override,
        capability kill,
        capability net_bind_service,
        capability net_raw,
        capability setgid,
        capability setuid,
        capability sys_chroot,

        network netlink dgram,
        network inet dgram,
        network inet6 dgram,

        ${avahiBin} mr,
        /nix/store/** r,
        /etc/avahi/ r,
        /etc/avahi/** r,
        /run/avahi-daemon/ w,
        /run/avahi-daemon/** rwk,
        /run/systemd/notify w,

        include if exists <local/usr.sbin.avahi-daemon>
      }
    '';
  };

  security.apparmor.policies."sbin.cupsd" = {
    state = "complain";
    profile = ''
      abi <abi/4.0>,
      include <tunables/global>

      profile cupsd ${cupsdBin} flags=(attach_disconnected) {
        include <abstractions/base>
        include <abstractions/bash>
        include <abstractions/dbus>
        include <abstractions/nameservice>
        include "${
          pkgs.apparmorRulesFromClosure { name = "cupsd"; } [
            pkgs.cups
            pkgs.gutenprint
            pkgs.gutenprintBin
            pkgs.epson-escpr
            pkgs.epson-escpr2
          ]
        }"

        capability chown,
        capability dac_override,
        capability fowner,
        capability fsetid,
        capability net_bind_service,
        capability setgid,
        capability setuid,

        network inet stream,
        network inet6 stream,
        network netlink dgram,

        ${cupsdBin} mr,
        /nix/store/** r,
        /etc/cups/ r,
        /etc/cups/** rw,
        /run/cups/ rw,
        /run/cups/** rw,
        /var/log/cups/ rw,
        /var/log/cups/** rw,
        /var/spool/cups/ rw,
        /var/spool/cups/** rw,
        /var/cache/cups/ rw,
        /var/cache/cups/** rw,
        /dev/usb/lp[0-9]* rw,
        /dev/bus/usb/** rw,

        include if exists <local/usr.sbin.cupsd>
      }
    '';
  };
}
