{ pkgs, lib, config, utils, inputs, ... }:

let
  types = lib.types;
  self = config.user-config;
  mkProgramOption = {
    name = lib.mkOption { type = types.nullOr types.str; default = null; };
    package = lib.mkOption { type = types.nullOr types.pacakge; default = null; };
    bin = lib.mkOption { type = types.nullOr types.str; default = null; };
    command = lib.mkOption { type = types.nullOr types.str; default = null; };
  };
in {
  imports = (utils.recReadDir ../modules);

  options.user-config = {
    enable = lib.mkEnableOption "User Configuration";
    name = lib.mkOption { type = types.str; };
    home = lib.mkOption {
      type = types.str;
      default = "/home/${self.name}";
    };
    dotfiles = lib.mkOption {
      type = types.str;
      default = "${self.home}/dotfiles";
    };
    email = lib.mkOption { type = types.nullOr types.str; default = null; };
    wallpaper = lib.mkOption { type = types.str; default = "wallpaper.png"; };

    pref = {
      theme = lib.mkOption {
        type = types.enum (builtins.attrNames utils.config.themes);
        default = "darkslate";
      };
      color = lib.mkOption {
        type = types.enum (builtins.attrNames utils.config.colors);
        default = "darkslate";
      };
      variant = lib.mkOption {
        type = types.str;
        default = "default";
      };
      dark = lib.mkEnableOption "Prefer dark for any application";
    };

    font = {
      emoji = lib.mkOption { type = types.nullOr types.str; default = null; };
      monospace = lib.mkOption { type = types.nullOr types.str; default = null; };
      sansSerif = lib.mkOption { type = types.nullOr types.str; default = null; };
      serif = lib.mkOption { type = types.nullOr types.str; default = null; };
    };

    gui = {
      theme.name = lib.mkOption { type = types.nullOr types.str; default = null; };
      theme.package = lib.mkOption { type = types.nullOr types.package; default = null; };
      icon.name = lib.mkOption { type = types.nullOr types.str; default = null; };
      icon.package = lib.mkOption { type = types.nullOr types.package; default = null; };
      cursor.name = lib.mkOption { type = types.nullOr types.str; default = null; };
      cursor.package = lib.mkOption { type = types.nullOr types.package; default = null; };
      cursor.size = lib.mkOption { type = types.nullOr types.ints.unsigned; default = null; };
    };

    packages = lib.mkOption {
      type = types.listOf types.package;
      default = [];
    };

    dir = lib.mkOption {
      type = types.lazyAttrsOf types.str;
      default = {};
    };

    terminal = mkProgramOption // {
      defaultCommand = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };

    shell = mkProgramOption // {
      env = lib.mkOption {
        type = types.attrsOf types.str;
        default = {};
      };
      path = lib.mkOption {
        type = types.envVar;
        default = "";
      };
    };
    launcher = mkProgramOption;
    screenshot = mkProgramOption;
    browser = mkProgramOption;
    editor = mkProgramOption;
  };

  config = lib.mkIf self.enable {
    lib.user-config.mkMutableSymlink = path:
      config.lib.file.mkOutOfStoreSymlink
        (self.dotfiles + lib.removePrefix (toString inputs.self) (toString path))
    ;

    user-config.terminal.defaultCommand = lib.mkDefault self.shell.command;
    user-config.dir = rec {
      Projects = "Projects";
      Downloads = "Downloads";
      Pictures = "Pictures";
      Screenshots = "${Pictures}/Screenshots";
    };

    programs.home-manager.enable = true;
    home = {
      username = self.name;
      homeDirectory = self.home;
      stateVersion = "24.11";
      activation = {
        userConfigMakeHomeDirectory = lib.hm.dag.entryAfter
          ["writeBoundary"]
          (''
            if [ ! -d "${self.home}" ]; then
              run mkdir -p ${self.home}
            fi
          ''
            + (builtins.foldl'
              (acc: dir:
                acc + ''
                  if [ ! -d "${self.home}/${dir}" ]; then
                    run mkdir -p ${self.home}/${dir}
                  fi
                ''
              )
              ""
              (builtins.attrValues self.dir)
            )
          )
        ;
      };
      pointerCursor = {
        gtk.enable = true;
        name = self.gui.cursor.name;
        package = self.gui.cursor.package;
        size = self.gui.cursor.size;
      };
      sessionVariables = {
        SHELL = self.shell.command;
        PATH = "$PATH:" + self.shell.path;
      } // self.shell.env;
      file = {
        "${self.dir.Pictures}/${self.wallpaper}".source = ../resources + "/${self.wallpaper}";
      } // (builtins.foldl'
        (acc: name: acc // {
          ".config/${name}" = {
            recursive = true;
            source = config.lib.user-config.mkMutableSymlink (../config + "/${name}");
          };
        })
        {}
        (builtins.attrNames (builtins.readDir ../config))
      );
    };

    gtk = {
      enable = true;
      iconTheme.name = self.gui.icon.name;
      iconTheme.package = self.gui.icon.package;
      cursorTheme.name = self.gui.cursor.name;
      cursorTheme.package = self.gui.cursor.package;
      cursorTheme.size = self.gui.cursor.size;
      theme.name = self.gui.theme.name;
      theme.package = self.gui.theme.package;
    };

    dconf.settings = utils.mkAttrWithCondition {
      preferDark = self.pref.dark;
    } {
      preferDark."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = (builtins.foldl'
        (acc: name: acc // (
          if self.font.${name} == null then
            {}
          else
            { ${name} = [ self.font.${name} ]; }
          )
        )
        {}
        (builtins.attrNames self.font)
      );
    };
  };
}
