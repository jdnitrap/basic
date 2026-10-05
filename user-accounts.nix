#user-accounts.nix

{config, lib, pkgs, inputs, ... }:

{

users.users."nimda" = {
    isNormalUser = true;
    description = "nimda";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


}
