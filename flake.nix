{
  description = "NixOS configuration (flake conversion of configuration.nix)";

  inputs = {
    # Matches system.stateVersion = "26.05" in configuration.nix.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations."hostnamehere" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # configuration.nix already imports ./hardware-configuration.nix,
        # so it is deliberately NOT listed here a second time.
        ./configuration.nix
      ];
    };
  };
}
