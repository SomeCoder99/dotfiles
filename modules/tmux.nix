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
        set -g default-command "${user.data.shell.bin or "bash"}"

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
      '' + (utils.config.getTheme "tmux" user);
    };
    user-config.terminal.defaultCommand = "${pkgs.tmux.outPath}/bin/tmux";
  };
}
