{ config, pkgs, lib, ... }: {
  options.desktop = {
    enable = lib.mkEnableOption "enables a desktop environment via hyprland";
    waybarMonitor = lib.mkOption {
      default = "DP-1";
      example = "DP-1";
      type = lib.types.str;
      description = "Waybar monitor";
    };
    monitors = lib.mkOption {
      default = [
        "HDMI-A-1, 2560x1440, 0x0, 1, transform, 1"
        "DP-1, 3440x1440, 1440x1200, 1"
      ];
      example = [ "DVI-D-1, 1680x1050, 0x0, 1" "DP-1, 3440x1440, 1680x0, 1" ];
      type = lib.types.listOf lib.types.str;
      description = "Hyprland monitors";
    };
  };

  config = lib.mkIf config.desktop.enable {
    home.packages = with pkgs; [
      mako
      xdg-desktop-portal-hyprland
      kdePackages.polkit-kde-agent-1
      vesktop
      font-awesome
      usbutils
      blueman
      spotify
    ];

    services = {
      hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";

          preload = [ "/home/alwin/wallpaper.webp" ];

          wallpaper = [ "DP-1,/home/alwin/wallpaper.webp" ];
        };
      };
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 120;
              on-timeout = "hyprlock";
            }
            {
              timeout = 300;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };

    programs = {
      rofi = { enable = true; };
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            output = config.desktop.waybarMonitor;
            # "layer": "top", // Waybar at top layer
            #// "position": "bottom", // Waybar position (top|bottom|left|right)
            #        height = 15; #// Waybar height (to be removed for auto height)
            #// "width": 1280, // Waybar width
            spacing = 100; # // Gaps between modules (4px)
            #// Choose the order of the modules
            modules-center = [ "clock" ];
            modules-right = [ "bluetooth" "battery" ];
            clock = {
              # "timezone": "America/New_York",
              #tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%d-%m-%Y}";
            };
            battery = { format = "{capacity}%"; };
            bluetooth = {
              format = " {status}";
              format-disabled = ""; # an empty format will hide the module
              format-connected = "{num_connections}  ";
              tooltip-format = "{controller_alias}	{controller_address}";
              tooltip-format-connected = ''
                {controller_alias}	{controller_address}

                {device_enumerate}'';
              tooltip-format-enumerate-connected =
                "{device_alias}	{device_address}";
            };
            #wireplumber = {
            #  format = "{volume}%";
            #  format-muted = "";
            #  format-icons = [ "" "" "" ];
            #};
          };
        };
        style = ''
          * { font-size: 15px; }
          window#waybar {
           background: transparent;
          }
          #clock {
           background: transparent;
           color: white;
           padding: 10px 0 0 0;
          }
          #battery {
           background: transparent;
           color: white;
           padding: 10px 0 0 0;
          }
          #bluetooth {
           background: transparent;
           color: white;
           padding: 10px 0 0 0;
          }
          #wireplumber {
           background: transparent;
           color: white;
           padding: 10px 0 0 0;
          }
        '';
      };
    };

    catppuccin.hyprland.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        monitor = config.desktop.monitors;

        workspace = [ " 1, monitor:HDMI-A-1" "2, monitor:DP-1" ];
      };
      extraConfig = ''

        exec-once = mako & polkit-kde-agent & waybar

        $terminal = kitty

        env = XCURSOR_SIZE,24
        env = QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input {
            kb_layout = de
            kb_variant =
            kb_model =
            kb_options =
            kb_rules =

            follow_mouse = 1

            touchpad {
                natural_scroll = yes
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

            natural_scroll = true
        }

        general {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            gaps_in = 5
            gaps_out = 20
            border_size = 2
            col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
            col.inactive_border = rgba(595959aa)

            layout = dwindle

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false
        }

        decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 10

            blur {
                enabled = true
                size = 3
                passes = 1
            }

        }

        animations {
            enabled = yes

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = myBezier, 0.05, 0.9, 0.1, 1.05

            animation = windows, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            animation = borderangle, 1, 8, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
        }

        dwindle {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = yes # you probably want this
        }

        master {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_status = master
        }

        gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = off
        }

        misc {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
        }

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        $mainMod = SUPER

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, T, exec, $terminal
        bind = $mainMod, K, killactive,
        bind = $mainMod, M, exit,
        bind = $mainMod, J, togglesplit, # dwindle
        bind = $mainMod, F, fullscreen, 1
        bind = $mainMod, B, exec, firefox
        bind = $mainMod, D, exec, vesktop
        bind = $mainMod, P, exec, steam
        bind = $mainMod, L, exec, hyprlock
        bind = $mainMod, R, exec, rofi -show run

        # Move focus with mainMod + arrow keys
        bind = $mainMod, h, movefocus, l
        bind = $mainMod, l, movefocus, r
        bind = $mainMod, k, movefocus, u
        bind = $mainMod, j, movefocus, d

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Example special workspace (scratchpad)
        bind = $mainMod, S, togglespecialworkspace, magic
        bind = $mainMod SHIFT, S, movetoworkspace, special:magic

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow

        bindm = $mainMod, mouse:273, resizewindow
        bind = $mainMod SHIFT, h, resizeactive, 10 0
        bind = $mainMod SHIFT, j, resizeactive, 0 10
        bind = $mainMod SHIFT, k, resizeactive, 0 -10
        bind = $mainMod SHIFT, l, resizeactive, -10 0

        #sound
        bindel=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        bindel=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindl=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      '';
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 1;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [{
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }];
        authentication = { "pam:module" = "login"; };

        input-field = [{
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          shadow_passes = 2;
        }];
      };
    };
  };
}
