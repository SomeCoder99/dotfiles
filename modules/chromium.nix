{ config, utils, lib, pkgs, ... }:

let
  user = config.user-config;
  self = user.modules.chromium;
in {
  options.user-config.modules.chromium = {
    enable = lib.mkEnableOption "chromium";
  };

  config = lib.mkIf self.enable {
    programs.chromium = {
      enable = true;
      extensions = utils.mkListWithCondition {
        dark = user.pref.dark;
      } {
        default = [
          { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
        ];
        dark = [
          { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        ];
      };
    };

    user-config.browser = lib.mkDefault rec {
      name = "chromium";
      package = pkgs.${name};
      bin = "${package.outPath}/bin/${name}";
      command = bin;
    };
  };
}
