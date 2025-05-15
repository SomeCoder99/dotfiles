{ config, lib, utils, pkgs, ... }:

let
  user = config.user-config;
  self = user.modules.ghostty;
in {
  options.user-config.modules.ghostty = {
    enable = lib.mkEnableOption "ghostty";
  };

  config = lib.mkIf self.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = user.pref.theme;
        font-size = 10;
        cursor-style = "block";
        command = user.terminal.defaultCommand or user.shell.bin;
        shell-integration-features = "no-cursor";
        app-notifications = "false";
        mouse-hide-while-typing = true;
        window-padding-x = 5;
        window-padding-y = 5;
        window-padding-balance = true;
        window-padding-color = "extend";
      };
      themes = let color = utils.config.getColor user; in {
        ${user.pref.theme} = {
          background = color.black;
          foreground = color.white;
          selection-background = color.brblack;
          selection-foreground = color.brwhite;
          cursor-color = color.brwhite;
          palette = [
            "0=#${color.black}"
            "1=#${color.red}"
            "2=#${color.green}"
            "3=#${color.yellow}"
            "4=#${color.blue}"
            "5=#${color.purple}"
            "6=#${color.cyan}"
            "7=#${color.white}"
            "8=#${color.brblack}"
            "9=#${color.brred}"
            "10=#${color.brgreen}"
            "11=#${color.bryellow}"
            "12=#${color.brblue}"
            "13=#${color.brpurple}"
            "14=#${color.brcyan}"
            "15=#${color.brwhite}"
          ];
        } // (utils.config.getTheme "ghostty" user);
      };
    };

    user-config.terminal = lib.mkDefault rec {
      name = "ghostty";
      package = pkgs.${name};
      bin = "${package.outPath}/bin/${name}";
      command = bin;
    };
  };
}
