{ config, pkgs, lib, utils, ... }:

let
  user = config.user-config;
  self = user.modules.hyprland;
in {
  options.user-config.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf self.enable {
    home.packages = [ pkgs.brightnessctl ];
    wayland.windowManager.hyprland = let mod = "SUPER"; in {
      enable = true;
      settings = {
        exec-once = [
          "hyprctl setcursor ${user.gui.cursor.name} ${toString user.gui.cursor.size}"
        ];

        general = {
          gaps_in = 10;
          gaps_out = 10;
          border_size = 0;
        };

        decoration = {
          rounding = 20;
          dim_inactive = true;
          dim_strength = 0.1;
          shadow.enabled = false;
          blur.enabled = false;
        };

        animations.enabled = false;

        input = {
          touchpad.natural_scroll = true;
          repeat_rate = 30;
          repeat_delay = 250;
        };

        bind = utils.mkListWithCondition {
          screenshot = user.screenshot.command != null;
          launcher = user.launcher.command != null;
          terminal = user.terminal.command != null;
        } {
          default = [
            "${mod}, C, killactive"
            "${mod}, V, togglefloating"
            "${mod}, F, fullscreen"
            "${mod} SHIFT, M, exit"

            "${mod}, up, movefocus, u"
            "${mod}, right, movefocus, r"
            "${mod}, down, movefocus, d"
            "${mod}, left, movefocus, l"

            "${mod}, S, togglespecialworkspace, magic"
            "${mod} SHIFT, S, movetoworkspace, special:magic"

            "${mod}, mouse_down, workspace, e+1"
            "${mod}, mouse_up, workspace, e-1"
          ];

          workspaces = (builtins.concatLists (builtins.genList
            (i: let ws = i + 1; in [
             "${mod}, ${toString ws}, workspace, ${toString ws}"
             "${mod} SHIFT, ${toString ws}, movetoworkspace, ${toString ws}"
            ])
            9
          ));

          terminal = [ "${mod}, Q, exec, ${user.terminal.bin}" ];
          launcher = [ "${mod}, X, exec, ${user.launcher.command}" ];
          screenshot = [ "${mod}, P, exec, ${user.screenshot.command}" ];
        };
        
        binde = [
          "${mod} CONTROL, 0, exec, brightnessctl set 2%+"
          "${mod} CONTROL, 9, exec, brightnessctl set 2%-"
        ];

        bindm = [
          "${mod}, mouse:272, movewindow"
          "${mod}, mouse:273, resizewindow"
        ];

        windowrule = [
          "rounding 0 bordersize 0,xwayland:1,class:()"
        ];
      };
    };
  };
}
