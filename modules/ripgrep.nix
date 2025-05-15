{ config, lib, ... }:

let
  user = config.user-config;
  self = user.modules.ripgrep;
in {
  options.user-config.modules.ripgrep = {
    enable = lib.mkEnableOption "ripgrep";
  };

  config = lib.mkIf self.enable {
    programs.ripgrep.enable = true;
  };
}
