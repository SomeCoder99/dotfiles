{ config, pkgs, lib, astal, ... }:

let
  user = config.user-config;
  self = user.modules.astal-widgets;
  types = lib.types;
in {
  options.user-config.modules.astal-widgets = {
    enable = lib.mkEnableOption "astal-widgets";
    package = lib.mkOption { type = types.package; };
  };

  config = lib.mkIf self.enable {
    user-config.modules.astal-widgets.package = lib.mkDefault (astal.lib.mkLuaPackage {
      inherit pkgs;
      name = "astal-widgets";
      src = ../apps/astal-widgets;
      extraPackages = with astal.packages.${pkgs.system}; [
        hyprland
        tray
        wireplumber
        network
        battery
        apps
      ];
    });

    home.packages = [ pkgs.brightnessctl self.package ];
    wayland.windowManager.hyprland.settings.exec-once = [
      "${self.package.outPath}/bin/astal-widgets"
    ];
  };
}
