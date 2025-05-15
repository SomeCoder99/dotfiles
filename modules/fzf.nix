{ config, lib, ... }:

let
  user = config.user-config;
  self = user.modules.fzf;
in {
  options.user-config.modules.fzf = {
    enable = lib.mkEnableOption "fzf";
  };

  config = lib.mkIf self.enable {
    programs.fzf.enable = true;
  };
}
