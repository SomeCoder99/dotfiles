{
  description = "NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    astal.url = "github:aylur/astal";
    astal.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, astal }: let
    importUsers = directory: args:
      let dir = builtins.readDir directory; in
      builtins.foldl'
        (acc: name: acc ++ (
          let
            path = "${directory}/${name}";
            mapUser = user: user // {
              modules = (builtins.mapAttrs (n: v: v // { enable = true; }) user.modules);
            };
          in if dir.${name} == "directory" then
            [ (mapUser (import "${path}/user.nix" args) // { userAtMachine = name; }) ]
          else
            [ (mapUser (import path args) // { userAtMachine = name; }) ]
        ))
        []
        (builtins.attrNames dir)
    ;
    pkgs = nixpkgs.legacyPackages.${host.system};
    utils = import ./lib/utils.nix;
    users = importUsers ./users { inherit pkgs utils; };
    host = {
      system = "x86_64-linux";
      name = "nixos";
      timezone = "Asia/Jakarta";
      locale = "en_US.UTF-8";
    };
  in {
    nixosConfigurations.${host.name} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit host users; libutils = utils; };
      modules = [ ./host/configuration.nix ];
    };
    homeConfigurations = builtins.foldl'
      (acc: user: acc // {
        ${user.userAtMachine} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit utils astal; };
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
