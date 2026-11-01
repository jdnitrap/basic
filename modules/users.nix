{ ... }:

{
  users.mutableUsers = true;
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };
  services.accounts-daemon.enable = true;
}
