{ config, pkgs, lib, utils, ... }:

let
  user = config.user-config;
  self = user.modules.flameshot;
  types = lib.types;
in {
  options.user-config.modules.flameshot = {
    enable = lib.mkEnableOption "flameshot";
    wayland = lib.mkEnableOption "wayland";
    package = lib.mkOption {
      type = types.package;
    };
  };

  config = lib.mkIf self.enable {
    user-config.modules.flameshot.package = lib.mkDefault (if self.wayland then
      pkgs.flameshot.overrideAttrs (_: {
        cmakeFlags = [
          "-DUSE_WAYLAND_CLIPBOARD=1"
          "-DUSE_WAYLAND_GRIM=1"
        ];
      })
    else
      pkgs.flameshot
    );

    home.packages = lib.mkIf self.wayland [ pkgs.grim ];
    services.flameshot = {
      package = self.package;
      enable = true;
      settings = {
        General = let color = utils.config.getColor user; in {
          userColors = "picker,#${color.black},#${color.red},#${color.orange},#${color.yellow},#${color.green},#${color.cyan},#${color.blue},#${color.purple},#${color.white}";
          savePath = "${user.home}/${user.dir.Screenshots}";
          showHelp = false;
        } // (utils.config.getTheme "flameshot" user);
      };
    };

    user-config.screenshot = lib.mkDefault rec {
      name = "flameshot";
      package = self.package;
      bin = "${package.outPath}/bin/${name}";
      command = "${bin} gui";
    };
  };
}
