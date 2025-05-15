{ config, lib, pkgs, ... }:

let
  user = config.user-config;
  self = user.modules.neovim;
in {
  options.user-config.modules.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf self.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    user-config.editor = lib.mkDefault rec {
      name = "neovim";
      package = pkgs.${name};
      bin = "${package.outPath}/bin/nvim";
      command = bin;
    };
  };
}
