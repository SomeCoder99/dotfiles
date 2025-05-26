{ pkgs, ... }:

let self = {
  name = "rizwan";
  groups = [ "wheel" ];
  email = "r1zone.el4nsy4h@gmail.com";
  pref = {
    theme = "darkslate";
    dark = true;
  };

  modules = {
    hyprland = {};
    astal-widgets = {};
    hyprpaper = {};
    flameshot.wayland = true;
    rofi.wayland = true;
    chromium = {};
    ghostty = {};

    tmux = {};
    fish = {};
    ripgrep = {};
    direnv = {};
    fzf = {};
    bat = {};

    neovim = {};
    git.username = "SomeCoder99";
  };

  font = {
    monospace = "JetBrainsMono Nerd Font";
  };

  gui = {
    icon.name = "Colloid-Dark";
    icon.package = pkgs.colloid-icon-theme;
    cursor.name = "Simp1e-Dark";
    cursor.package = pkgs.simp1e-cursors;
    cursor.size = 24;
    theme.name = "Colloid-Dark";
    theme.package = pkgs.colloid-gtk-theme;
  };

  packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    gcc ccls
    cargo rust-analyzer rustfmt
    nodejs_24
    php php84Packages.composer phpactor blade-formatter
    lua lua-language-server stylua
    nil
    tree-sitter
    laravel
  ];
};
in self
