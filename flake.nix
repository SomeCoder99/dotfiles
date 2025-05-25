{
  description = "NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    astal.url = "github:aylur/astal";
    astal.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, astal }@inputs: let
    pkgs = nixpkgs.legacyPackages.${host.system};
    utils = import ./lib/utils.nix;
    users = utils.importUsers ./users { inherit pkgs utils; };
    host = {
      system = "x86_64-linux";
      name = "nixos";
      timezone = "Asia/Jakarta";
      locale = "en_US.UTF-8";
    };
  in {
    nixosConfigurations.${host.name} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit host users inputs; libutils = utils; };
      modules = [ ./host/configuration.nix ];
    };
    homeConfigurations = builtins.foldl'
      (acc: user: acc // {
        ${user.userAtMachine} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit utils astal inputs; };
          modules = [
            ./lib/user-config.nix
            { user-config = builtins.removeAttrs user ["groups" "userAtMachine"] // { enable = true; }; }
          ];
        };
      })
      {}
      users
    ;
  };
}
