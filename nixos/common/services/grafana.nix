{ pkgs, lib, config, ... }:
let cfg = config.custom.grafana;
in {
  options.custom.grafana = {
    enable =
      lib.mkEnableOption "Enables grafana with prometheus and node_exporter";
  };

  config = lib.mkIf cfg.enable {
    environment.etc."grafana-dashboards/system-metrics.json".text = builtins.toJSON {
      title = "System Metrics";
      uid = "system-metrics";
      timezone = "browser";
      schemaVersion = 16;
      refresh = "30s";
      panels = [
          {
            id = 1;
            title = "CPU Usage";
            type = "timeseries";
            gridPos = { x = 0; y = 0; w = 12; h = 8; };
            targets = [{
              expr = ''100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)'';
              legendFormat = "CPU Usage";
              refId = "A";
            }];
            fieldConfig = {
              defaults = {
                unit = "percent";
                min = 0;
                max = 100;
                custom = {
                  drawStyle = "line";
                  lineInterpolation = "smooth";
                  fillOpacity = 10;
                };
              };
            };
            options = {
              legend = { displayMode = "list"; placement = "bottom"; };
              tooltip = { mode = "single"; };
            };
          }
          {
            id = 2;
            title = "Memory Usage";
            type = "timeseries";
            gridPos = { x = 12; y = 0; w = 12; h = 8; };
            targets = [{
              expr = ''(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100'';
              legendFormat = "Memory Usage";
              refId = "A";
            }];
            fieldConfig = {
              defaults = {
                unit = "percent";
                min = 0;
                max = 100;
                custom = {
                  drawStyle = "line";
                  lineInterpolation = "smooth";
                  fillOpacity = 10;
                };
              };
            };
            options = {
              legend = { displayMode = "list"; placement = "bottom"; };
              tooltip = { mode = "single"; };
            };
          }
          {
            id = 3;
            title = "Disk Usage";
            type = "timeseries";
            gridPos = { x = 0; y = 8; w = 12; h = 8; };
            targets = [{
              expr = ''(1 - (node_filesystem_avail_bytes{fstype!="tmpfs",fstype!="ramfs"} / node_filesystem_size_bytes)) * 100'';
              legendFormat = "{{mountpoint}}";
              refId = "A";
            }];
            fieldConfig = {
              defaults = {
                unit = "percent";
                min = 0;
                max = 100;
                custom = {
                  drawStyle = "line";
                  lineInterpolation = "smooth";
                  fillOpacity = 10;
                };
              };
            };
            options = {
              legend = { displayMode = "list"; placement = "bottom"; };
              tooltip = { mode = "multi"; };
            };
          }
          {
            id = 4;
            title = "ZFS Available Storage";
            type = "timeseries";
            gridPos = { x = 12; y = 8; w = 12; h = 8; };
            targets = [{
              expr = ''node_filesystem_avail_bytes{fstype="zfs",device=~"data|large"}'';
              legendFormat = "{{device}}";
              refId = "A";
            }];
            fieldConfig = {
              defaults = {
                unit = "bytes";
                custom = {
                  drawStyle = "line";
                  lineInterpolation = "smooth";
                  fillOpacity = 10;
                };
              };
            };
            options = {
              legend = { displayMode = "list"; placement = "bottom"; };
              tooltip = { mode = "multi"; };
            };
          }
          {
            id = 5;
            title = "Network Traffic";
            type = "timeseries";
            gridPos = { x = 0; y = 16; w = 12; h = 8; };
            targets = [
              {
                expr = ''rate(node_network_receive_bytes_total{device!="lo"}[5m])'';
                legendFormat = "{{device}} RX";
                refId = "A";
              }
              {
                expr = ''rate(node_network_transmit_bytes_total{device!="lo"}[5m])'';
                legendFormat = "{{device}} TX";
                refId = "B";
              }
            ];
            fieldConfig = {
              defaults = {
                unit = "Bps";
                custom = {
                  drawStyle = "line";
                  lineInterpolation = "smooth";
                  fillOpacity = 10;
                };
              };
            };
            options = {
              legend = { displayMode = "list"; placement = "bottom"; };
              tooltip = { mode = "multi"; };
            };
          }
          {
            id = 6;
            title = "System Load";
            type = "timeseries";
            gridPos = { x = 12; y = 16; w = 12; h = 8; };
            targets = [
              { expr = "node_load1"; legendFormat = "1 minute"; refId = "A"; }
              { expr = "node_load5"; legendFormat = "5 minutes"; refId = "B"; }
              { expr = "node_load15"; legendFormat = "15 minutes"; refId = "C"; }
            ];
            fieldConfig = {
              defaults = {
                unit = "short";
                custom = {
                  drawStyle = "line";
                  lineInterpolation = "smooth";
                  fillOpacity = 10;
                };
              };
            };
            options = {
              legend = { displayMode = "list"; placement = "bottom"; };
              tooltip = { mode = "multi"; };
            };
          }
          {
            id = 7;
            title = "Disk I/O Utilization";
            type = "timeseries";
            gridPos = { x = 0; y = 24; w = 12; h = 8; };
            targets = [{
              expr = ''rate(node_disk_io_time_seconds_total{device=~"sd.*|nvme.*"}[5m]) * 100'';
              legendFormat = "{{device}}";
              refId = "A";
            }];
            fieldConfig = {
              defaults = {
                unit = "percent";
                min = 0;
                max = 100;
                custom = {
                  drawStyle = "line";
                  lineInterpolation = "smooth";
                  fillOpacity = 10;
                };
              };
            };
            options = {
              legend = { displayMode = "list"; placement = "bottom"; };
              tooltip = { mode = "multi"; };
            };
          }
          {
            id = 8;
            title = "Disk Throughput";
            type = "timeseries";
            gridPos = { x = 12; y = 24; w = 12; h = 8; };
            targets = [
              {
                expr = ''rate(node_disk_read_bytes_total{device=~"sd.*|nvme.*"}[5m])'';
                legendFormat = "{{device}} Read";
                refId = "A";
              }
              {
                expr = ''rate(node_disk_write_bytes_total{device=~"sd.*|nvme.*"}[5m])'';
                legendFormat = "{{device}} Write";
                refId = "B";
              }
            ];
            fieldConfig = {
              defaults = {
                unit = "Bps";
                custom = {
                  drawStyle = "line";
                  lineInterpolation = "smooth";
                  fillOpacity = 10;
                };
              };
            };
            options = {
              legend = { displayMode = "list"; placement = "bottom"; };
              tooltip = { mode = "multi"; };
            };
          }
        ];
    };

    services.grafana = {
      enable = true;
      dataDir = "/data/grafana";
      settings.database = {
        type = "postgres";
        host = "/run/postgresql";
        name = "grafana";
        user = "grafana";
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [{
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:9090";
          isDefault = true;
        }];
        dashboards.settings.providers = [{
          name = "System Metrics";
          type = "file";
          options.path = "/etc/grafana-dashboards";
        }];
      };
    };

    services.postgresql = {
      ensureDatabases = [ "grafana" ];
      ensureUsers = [{
        name = "grafana";
        ensureDBOwnership = true;
      }];
    };

    services.prometheus = {
      enable = true;
      port = 9090;
      retentionTime = "7d";

      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" "zfs" ];
          port = 9100;
        };
      };

      scrapeConfigs = [{
        job_name = "node";
        static_configs = [{
          targets = [
            "127.0.0.1:${
              toString config.services.prometheus.exporters.node.port
            }"
          ];
        }];
      }];
    };

    services.nginx.virtualHosts."grafana.stockinger.tech" = {
      useACMEHost = "stockinger.tech";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000/";
        proxyWebsockets = true;
      };
    };
  };
}
