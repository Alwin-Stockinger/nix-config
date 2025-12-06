{ pkgs, lib, config, ... }: {
  options.custom.postgres.enable =
    lib.mkEnableOption "Enables postgres with sugar";

  config = lib.mkIf config.custom.postgres.enable {
    services.postgresql = {
      dataDir = "/data/postgres/pgdata";
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';
    };
    services.postgresqlBackup = {
      enable = true;
      backupAll = true;
      location = "/large/backups";
    };
  };
}
