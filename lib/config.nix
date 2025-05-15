{ importDir, ... }:

let
  t = builtins.foldl' (acc: theme: acc // { colors = theme.colors; themes = theme.themes; }) {} (importDir ../themes);
in rec {
  themes = t.themes;
  colors = t.colors;

  getColor = config: # 'config' is user-config
    (colors.${config.pref.color} or (throw "no color palette with name ${config.pref.color}"))
    .${config.pref.variant} or (throw "no ${config.pref.variant} variant in color palette ${config.pref.color}")
  ;

  getTheme = name: config: let # 'config' is user-config
    theme = themes.${config.pref.theme};
    color = getColor config;
    ok =
      if theme ? isCompat then
        theme.isCompat color
      else let
        themeColor = colors.${config.pref.theme}.default or (throw "${config.pref.theme} theme doesn't have isCompat attribute or it's color palette");
      in (builtins.foldl'
        (ok: name: ok && color ? ${name})
        true
        (builtins.attrNames themeColor)
      ) && color?black && color?white && color?red && color?orange && color?yellow
        && color?green && color?cyan && color?blue && color?purple
        && color?brblack && color?brwhite && color?brred && color?brorange && color?bryellow
        && color?brgreen && color?brcyan && color?brblue && color?brpurple
    ; in if ok then
      if theme ? ${name} then
        theme.${name} color
      else
        {}
    else
      throw "${config.pref.color} color palette is incompatible with ${config.pref.theme} theme"
  ;
}
