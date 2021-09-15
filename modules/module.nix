moduleConfig:
{ lib, pkgs, config, ... }:

with lib;

{
  options.services.nixos-hm-auto-update = with types;{
    enable = mkEnableOption "Auto update NixOS Home Manager weekly";
    gitPackage = mkOption {
      type = package;
      default = pkgs.git;
    };
  };

  config =
    let
      cfg = config.services.nixos-hm-auto-update;
      gitPath = "${cfg.gitPackage}/bin/git";
      mkStartScript = name: pkgs.writeShellScript "${name}.sh" ''
        set -euo pipefail
        PATH=${makeBinPath (with pkgs; [ git ])}
        export NIX_PATH="nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix"
        cd ~/.config/nixpkgs
        ${gitPath} pull origin main
        $HOME/.nix-profile/bin/home-manager switch - -flake ".#$USER" - v
      '';
    in
    mkIf cfg.enable (
      moduleConfig rec {
        name = "nixos-hm-auto-update";
        description = "Auto update NixOS Home Manager weekly";
        serviceConfig = {
          ExecStart = "${mkStartScript name}";
        };
        timerConfig = {
          OnBootSec = "5m"; # first run 5min after boot up
          #OnUnitActiveSec = "1w"; # run weekly
        };
      }
    );
}
