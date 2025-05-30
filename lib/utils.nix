rec {
  recReadDir = dir:
    let paths = builtins.readDir dir; in
    builtins.foldl'
      (acc: name: acc ++ (
        let path = dir + "/${name}"; in
        if paths.${name} == "directory" then
          recReadDir path
        else
          [ path ]
      ))
      []
      (builtins.attrNames paths)
  ;

  importDir = directory:
    let dir = builtins.readDir directory; in
    builtins.foldl'
      (acc: name: acc ++ (
        let path = "${directory}/${name}"; in
        if dir.${name} == "directory" then
          [ (import "${path}/default.nix") ]
        else
          [ (import path) ]
      ))
      []
      (builtins.attrNames dir)
  ;

  mkListWithCondition = (conditions: lists: builtins.foldl'
    (acc: name:
      if conditions.${name} or true then
        acc ++ lists.${name}
      else
        acc
    )
    []
    (builtins.attrNames lists)
  );

  mkAttrWithCondition = (conditions: attrs: builtins.foldl'
    (acc: name:
      if conditions.${name} or true then
        acc // attrs.${name}
      else
        acc
    )
    {}
    (builtins.attrNames attrs)
  );

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

  config = import ./config.nix { inherit importDir; };
}
