{
  description = "NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: let
    pkgs = nixpkgs.legacyPackages.${host.system};
    utils = import ./lib/utils.nix;
    users = builtins.map
      (f: let user = f { inherit pkgs; }; in user // {
        modules = (builtins.mapAttrs (n: v: v // { enable = true; }) user.modules);
      })
      (utils.importDir ./users)
    ;
    host = {
      system = "x86_64-linux";
      name = "laptop";
      timezone = "Asia/Jakarta";
      locale = "en_US.UTF-8";
    };
  in {
    nixosConfigurations.${host.name} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit host users utils; };
      modules = [ ./host/configuration.nix ];
    };
    homeConfigurations = builtins.foldl'
      (acc: user: acc // {
        ${user.name} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit utils; };
          modules = [
            ./lib/user-config.nix
            { user-config = (builtins.removeAttrs user ["groups"]) // { enable = true; }; }
          ];
        };
      })
      {}
      users
    ;
  };
}
