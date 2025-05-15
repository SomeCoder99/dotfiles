{ config, pkgs, lib, utils, ... }:

let
  user = config.user-config;
  self = user.modules.tmux;
in {
  options.user-config.modules.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf self.enable {
    programs.tmux = {
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      prefix = "C-x";
      extraConfig = ''
        bind | split-window -h
        bind _ split-window -v
        bind a new-window -c "#{pane_current_path}"
        bind z previous-window
        bind c next-window
        unbind '"'
        unbind %
        unbind C-z

        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        setw -g monitor-activity off
        set -g bell-action none

      ''
        + (if user.shell.command != null then
          ''

          set -g default-command "${user.shell.command}"

          ''
        else
          ""
        )
        + (utils.config.getTheme "tmux" user);
    };
    user-config.terminal.defaultCommand = lib.mkOverride 900 "${pkgs.tmux.outPath}/bin/tmux";
  };
}
