{ pkgs, inputs, ... }:

{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      # obsidian
      kmod
    ];
  };

  # BUG: Remove this once the upstream issue is resolved
  # https://github.com/microsoft/wsl/issues/11837
  # boot.kernelModules = [ "vgem" ];

  # systemd.tmpfiles.rules = [
  #   "L+ /usr/share/applications/obsidian.desktop - - - - /run/current-system/sw/share/applications/obsidian.desktop"
  # ];


  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  virtualisation.docker.enable = true;

  users.users.aki543 = {
    isNormalUser = true;
    home = "/home/aki543";
    uid = 1001;
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;

    # yescrypt
    hashedPassword = "$y$j9T$t8WjVMD50ya3UCvODMLWg0$n7XE3pMkQa2sh/cfxLu3AI1lkHLOh7F/jYcH4UZjge6";
  };
}
