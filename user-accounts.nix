#user-accounts.nix

{config, lib, pkgs, ... }:

{
  users.mutableUsers = true;

  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };
}
