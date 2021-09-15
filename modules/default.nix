import ./module.nix ({ name, description, serviceConfig, timerConfig }:

  {
    systemd.services.${name} = {
      inherit description serviceConfig;
      wantedBy = [ "default.target" ];
    };

    systemd.timers.${name} = {
      inherit description timerConfig;
      wantedBy = [ "timers.target" ];
    };
  })
