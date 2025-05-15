{ config, lib, ... }:

let
  user = config.user-config;
  self = user.modules.git;
  types = lib.types;
in {
  options.user-config.modules.git = {
    enable = lib.mkEnableOption "git";
    branch = lib.mkOption { type = types.str; default = "main"; };
    username = lib.mkOption { type = types.str; };
  };

  config = lib.mkIf self.enable {
    programs.git = {
      enable = true;
      userEmail = user.email;
      userName = self.username;
      extraConfig = {
        init.defaultBranch = self.branch;
        credential.helper = "store";
      };
    };
  };
}
