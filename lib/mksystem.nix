{ nixpkgs, overlays, inputs }:

name:
{
  system,
  user,
  wsl ? false
}:

let
  isWSL = wsl;

  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/${user}/nixos.nix;
  userHWConfig = ../users/${user}/home.nix;

  systemFunc = nixpkgs.lib.nixosSystem;
  home-manager = inputs.home-manager.nixosModules;

  inherit (nixpkgs.lib) optionals;
in nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    # { nixpkgs.config.allowUnfree = true; }
    { nixpkgs.overlays = overlays; }
  ] ++ optionals isWSL [
    inputs.nixos-wsl.nixosModules.wsl
  ] ++ [
    machineConfig
    userOSConfig
    home-manager.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users.${user} = import userHWConfig {
          isWSL = isWSL;
          inputs = inputs;
        };
      };
    }
    {
      config._module.args = {
        System = system;
        SystemName = name;
        systemUser = user;
        # isWSL = isWSL;
      };
    }
  ];
}
