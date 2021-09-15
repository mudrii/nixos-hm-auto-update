{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
  };
  description = "Auto update NixOS weekly";
  outputs = { self, nixpkgs }: {
    nixosModules = {
      system = import ./modules;
    };
  };
}
