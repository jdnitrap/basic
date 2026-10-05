#hosts/hostnamehere.nix

{ config, pkgs, lib, ... }:

{
  imports = [ ../hardware-configuration.nix ];

  networking.hostName = "hostnamehere";
}
