{ config, lib, ... }:

let
  user = config.user-config;
  self = user.modules.hyprpaper;
in {
  options.user-config.modules.hyprpaper = {
    enable = lib.mkEnableOption "hyprpaper";
  };

  config = lib.mkIf self.enable (let
    wallpaper = "${user.home}/${user.dir.Pictrues}/${user.wallpaper}";
  in {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ wallpaper ];
        wallpaper = [ "eDP-1,contain:${wallpaper}" ];
      };
    };
  });
}
