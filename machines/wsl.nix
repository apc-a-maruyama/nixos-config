{ pkgs, systemUser, ... }: {
  imports = [];

  wsl = {
    enable = true;
    defaultUser = systemUser;
    wslConf.automount.root = "/mnt";
    startMenuLaunchers = true;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # keep-outputs = true;
      # keep-derivations = true;
    };
  };

  system.stateVersion = "26.05";
}
