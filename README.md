# Service to auto update NixOS Home Manager weekly through GIT

Experimental support for upadting the Nixos with the latest update from github repo.

## Installation

### Install using flakes (flake.nix)

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-auto-update.url ="github:mudrii/nixos-hm-auto-update/main";
  };

  outputs = inputs@{self, nixpkgs, ...}: {
    nixosConfigurations.some-host = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # For more information of this field, check:
        # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/eval-config.nix
        modules = [
          ./configuration.nix
          {
            imports = [ inputs.nixos-hm-auto-update.nixosModules.system ];
          }
        ];
      };
  };
}
```

### Enable the service

systemctl enable nixos-hm-auto-update.service

### Start the service

systemctl start nixos-hm-auto-update.service

### Restart the service

The service can be restarted with `systemctl restart nixos-hm-auto-update` or by rebooting the machine.
