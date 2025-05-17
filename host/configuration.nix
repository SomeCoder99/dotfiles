{ pkgs, host, users, libutils, ... }:

let
  mods = builtins.foldl'
    (acc: user: acc // (user.modules or []))
    {}
    users
  ;
in {
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.device = "nodev";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = host.name;
  networking.networkmanager.enable = true;

  time.timeZone = host.timezone;

  i18n.defaultLocale = host.locale;
  console.font = "Lat2-Terminus16";

  services.pipewire = {
    enable = true;
    audio.enable = true;
  };

  services.libinput.enable = true;

  users.users = builtins.foldl' (acc: user: acc // {
    ${user.name} = {
      isNormalUser = true;
      extraGroups = user.groups;
    };
  }) {} users;

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  system.stateVersion = "24.11";

  programs = libutils.mkAttrWithCondition {
    hyprland = mods ? hyprland;
  } {
    hyprland = {
      hyprland.enable = true;
    };
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.upower.enable = true;
}

