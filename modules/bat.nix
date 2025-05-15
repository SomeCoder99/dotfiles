{ config, lib, ... }:

let
  user = config.user-config;
  self = user.modules.bat;
in {
  options.user-config.modules.bat = {
    enable = lib.mkEnableOption "bat";
  };

  config = lib.mkIf self.enable {
    programs.bat.enable = true;
  };
}
