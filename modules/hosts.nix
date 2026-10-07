{ self, nixpkgs, ... }:
let
  shared = [
    self.nixosModules.hardware-support
    self.nixosModules.system-setup
    self.nixosModules.sound
    self.nixosModules.state-version
    self.nixosModules.system-packages
    self.nixosModules.desktop
    self.nixosModules.boot
    self.nixosModules.networking
    self.nixosModules.user-accounts
    self.nixosModules.flatpak
    self.nixosModules.auto-update
    self.nixosModules.experimental-features
    self.nixosModules.laptop
    self.nixosModules.apparmor
  ];
in
{
  flake.nixosConfigurations.Asus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = shared ++ [
      ../hardware-configuration.nix
      { networking.hostName = "Asus"; }
    ];
  };

  flake.nixosConfigurations.minilap = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = shared ++ [
      ../hosts/minilap-hardware.nix
      { networking.hostName = "minilap"; }
    ];
  };
}
