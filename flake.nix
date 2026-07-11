{
  description = "NixOS systems and tools by Aki543";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # # spapd (package manager)
    # nix-snapd.url = "github:nix-community/nix-snapd";
    # nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jujutsu.url = "github:martinvonz/jj";
    zig.url = "github:mitchellh/zig-overlay";
    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    dotfiles = {
        url = "github:aki543/dotfiles";
        flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      overlays = [
        inputs.jujutsu.overlays.default
        inputs.zig.overlays.default

        (_final: prev: let
          system = prev.stdenv.hostPlatform.system;
          unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
        in {
          gh = unstable.gh;
        })
      ];

      mkSystem = import ./lib/mksystem.nix {
        inherit overlays nixpkgs inputs;
      };
    in {
      nixosConfigurations.wsl = mkSystem "wsl" {
        system = "x86_64-linux";
        user = "aki543";
        wsl = true;
      };

      # nixosConfigurations.surface = mkSystem "surface" {
      #   system = "x86_64-linux";
      #   user = "aki543";
      # };
      #
      # nixosConfigurations.proxmox = mkSystem "proxmox" {
      #   system = "x86_64-linux";
      #   user = "aki543";
      # };
      #
      # nixosConfigurations.macbook = mkSystem "macbook" {
      #   system = "aarch64-darwin";
      #   user = "aki543";
      # };
    };
}
