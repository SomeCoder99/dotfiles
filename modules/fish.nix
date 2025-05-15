{ config, lib, pkgs, ... }:

let
  user = config.user-config;
  self = user.modules.fish;
in {
  options.user-config.modules.fish = {
    enable = lib.mkEnableOption "fish";
  };

  config = lib.mkIf self.enable {
    home.shell.enableFishIntegration = true;
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = "";
        fish_prompt = ''
          set -l last_status $status
          set -l dir ""
          set -l prompt "$(set_color normal)λ "
          if [ "$PWD" != "$HOME" ]
            set dir "$(set_color cyan)$(basename $PWD)"
            set prompt " "
          end
      
          if [ $last_status != 0 ]
            set prompt "$(set_color red)?$(set_color normal) "
          end
      
          set -l git_status (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
          if [ ! -z "$git_status" ]
            if [ ! -z "$(command git status -s --ignore-submodules=dirty 2> /dev/null)" ]
              set git_status "$(set_color normal)*$(set_color green)$git_status "
            else
              set git_status "$(set_color normal)'$(set_color green)$git_status "
            end
          end
      
          printf "$git_status$dir$prompt$(set_color normal)"
        '';
      };
    };

    user-config.shell = rec {
      name = "fish";
      package = pkgs.${name};
      bin = "${package.outPath}/bin/${name}";
      command = bin;
    };
  };
}
