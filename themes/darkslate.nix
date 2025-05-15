{
  themes.darkslate = {
    ghostty = color: {
      background = color.dark1;
      foreground = color.dark12;
      selection-background = color.dark2;
      selection-foreground = color.dark13;
      cursor-color = color.cursor;
    };

    tmux = color: ''
      set-window-option -g window-status-style "bg=default,fg=#${color.blue0},dim"
      set-window-option -g window-status-current-style "fg=#${color.blue2},bg=default"
      set-option -g pane-border-style "fg=#${color.dark10}"
      set-option -g pane-active-border-style "fg=#${color.dark14}"

      set-option -g status-bg "#${color.dark2}"
      set-option -g status-style "bg=#${color.dark2},fg=default,default"
      set-option -g message-style "bg=#${color.bg-green},fg=default"

      set-option -g display-panes-active-colour "#${color.blue0}"
      set-option -g display-panes-colour "#${color.dark6}"
    '';

    flameshot = color: {
      uiColor = "#${color.blue0}";
      contrastUiColor = "#${color.dark4}";
      drawColor = "#${color.red0}";
    };
  };
  colors.darkslate = rec {
    default = dark;

    dark = rec {
      dark0 =         "101010";
      dark1 =         "181818";
      dark2 =         "1e1e1e";
      dark3 =         "2c2c2c";
      dark4 =         "313131";
      dark5 =         "3c3c3c";
      dark6 =         "484848";
      dark7 =         "4c4c4c";
      dark8 =         "545454";
      dark9 =         "5a5a5a";
      dark10 =        "626262";
      dark11 =        "6e6e6e";
      dark12 =        "797979";
      dark13 =        "848484";
      dark14 =        "919191";
      dark15 =        "a0a0a0";
      cursor =        "b2b2b2";

      bg-red =        "2e1717";
      dark-red =      "6a3232";
      red0 =          "854030";
      red1 =          "914545";
      red2 =          "994a4a";

      bg-orange =     "30261c";
      dark-orange =   "693f22";
      orange0 =       "855c32";
      orange1 =       "8f6235";
      orange2 =       "946435";

      bg-yellow =     "2e2b10";
      dark-yellow =   "504a25";
      yellow0 =       "848739";
      yellow1 =       "939643";
      yellow2 =       "9fa349";

      bg-green =      "122111";
      dark-green =    "194517";
      green0 =        "3b6939";
      green1 =        "437341";
      green2 =        "4f804d";

      bg-cyan =       "192629";
      dark-cyan =     "205a5a";
      cyan0 =         "448c8a";
      cyan1 =         "4c9694";
      cyan2 =         "52a19e";

      bg-blue =       "1f2133";
      dark-blue =     "272959";
      blue0 =         "545c8f";
      blue1 =         "5b6599";
      blue2 =         "6670a6";

      bg-purple =     "2b122b";
      dark-purple =   "552f55";
      purple0 =       "7a4385";
      purple1 =       "82498f";
      purple2 =       "8f519e";

      black = dark1;
      white = dark12;
      red = red0;
      orange = orange0;
      yellow = yellow0;
      green = green0;
      cyan = cyan0;
      blue = blue0;
      purple = purple0;

      brblack = dark3;
      brwhite = dark14;
      brred = red2;
      brorange = orange2;
      bryellow = yellow2;
      brgreen = green2;
      brcyan = cyan2;
      brblue = blue2;
      brpurple = purple2;
    };
  };
}
