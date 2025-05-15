{ config, lib, ... }:

let
  user = config.user-config;
  self = user.modules.direnv;
in {
  options.user-config.modules.direnv = {
    enable = lib.mkEnableOption "direnv";
  };

  config = lib.mkIf self.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
