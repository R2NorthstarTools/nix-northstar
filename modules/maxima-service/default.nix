{ self }:
{
  pkgs,
  lib,
  config,
  ...
}@args:

let
  cfg = config.services.maxima-service;
in
{
  options.services.maxima-service = {
    enable = lib.mkEnableOption "Enable maxima service";

    package = lib.mkPackageOption self.packages.${pkgs.stdenv.hostPlatform.system} "maxima-service" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.maxima-service = {
      description = "Maxima lsx service";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ];

      serviceConfig = {
        Restart = "always";
        KillSignal = "SIGINT";
        ExecStart = "${cfg.package}/bin/maxima-service";
      };
    };
  };
}
