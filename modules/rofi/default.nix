{ config, pkgs, lib, utils, ... }:

let
  user = config.user-config;
  self = user.modules.rofi;
  types = lib.types;
in {
  options.user-config.modules.rofi = {
    enable = lib.mkEnableOption "rofi";
    wayland = lib.mkEnableOption "wayland";
    package = lib.mkOption {
      type = types.package;
      default = if self.wayland then
        pkgs.rofi-wayland
      else
        pkgs.rofi
      ;
    };
  };

  config = lib.mkIf self.enable {
    home.packages = [ self.package ];
    user-config.launcher = lib.mkDefault rec {
      name = "rofi";
      package = self.package;
      bin = "${package.outPath}/bin/rofi";
      command = "${bin} -show drun";
    };

    home.file.".config/rofi/colors.rasi".text = utils.config.getTheme "rofi" user;
    home.file.".config/rofi/config.rasi".source = ./config/config.rasi;
    home.file.".config/rofi/theme.rasi".source = ./config/theme.rasi;
  };
}
