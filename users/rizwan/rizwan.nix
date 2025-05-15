{ pkgs, ... }:

{
  name = "rizwan";
  groups = [ "wheel" ];
  email = "r1zone.el4nsy4h@gmail.com";
  script = import ./script.nix;
  pref = {
    theme = "darkslate";
    dark = true;
  };

  modules = {
    hyprland = {};
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
    cursor.name = "Simp1e";
    cursor.package = pkgs.simp1e-cursors;
    cursor.size = 32;
    theme.name = "Colloid-Dark";
    theme.package = pkgs.colloid-gtk-theme;
  };

  packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    gcc ccls
    cargo rust-analyzer rustfmt
    lua lua-language-server stylua
    nil
    tree-sitter
  ];
}
