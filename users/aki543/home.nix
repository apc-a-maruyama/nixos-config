{ isWSL, inputs, ... }:
{ config, lib, pkgs, ... }:

let
  shellAliases = {
    # eza aliases
    ls = "eza --icons";
    ll = "eza -l --icons";
    la = "eza -la --icons";
    lla = "eza -lha --icons";
    lt = "eza --tree --level=2 --icons";
    # clear
    c = "clear";
    # nvim
    nv = "nvim";
    # zoxide
    z = "zoxide";
    # bat
    cat = "bat --style=plain --paging=never";
    # jujutsu
    jd = "jj desc";
    jf = "jj git fetch";
    jn = "jj new";
    jp = "jj git push";
    js = "jj st";

    # nix-rebuild="";
    # nix-gc="";
  };

  manpager = pkgs.writeShellScriptBin "manpager" ''cat "$1" | col -bx | bat -l man -p'';
in {
  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;

  xdg.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    eza
    curl
    fzf
    gh
    ghq
    htop
    # tree
    nodejs
    bat

    # _1password-cli
    asciinema
    # chezmoi
    watch

    # gopls
    # zigpkgs."0.15.2"
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";
  };

  home.file = {
    ".gdbinit".source = ./config/gdbinit;
    ".inputrc".source = ./config/inputrc;
  };
  xdg.configFile = {
    # "oh-my-posh".source = "${inputs.dotfiles}/.config/ohmyposh";
    "nvim".source = "${inputs.dotfiles}/.config/nvim";
  };

  # programs.gpg.enable = true; 

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    initExtra = builtins.readFile ./config/zshrc;
    shellAliases = shellAliases;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    signing = {
      key = "~/.ssh/github.pub";
      signByDefault = true;
    };
    extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.allowdSignersFile = "~/.ssh/allowed_signers";
    };
    settings = {
      user.name = "Aki543";
      user.email = "a_maruyama@ap-com.co.jp";
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "apc-a-maruyama";
      push.default = "tracking";
      init.defaultBranch = "main";
      ghq.root = "/home/aki543/.ghq";
    };
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      sw = "switch";

      root = "rev-parse --show-toplevel";
    };
  };

  programs.jujutsu = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;

    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [ gcc gnumake ];
  };

  programs.npm.enable = true;
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;

    configFile = ./config/theme.omp.json;
  };


  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = catppuccin;
        # BUG: https://github.com/catppuccin/tmux/issues/564
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_window_number_position 'right'
          set -g @catppuccin_window_status 'no'
          set -g @catppuccin_window_default_text '#W'
          set -g @catppuccin_window_current_fill 'number'
          set -g @catppuccin_window_current_text '#W'

          set -g @catppuccin_window_current_color '#{E:@thm_surface_2}'
          set -g @catppuccin_status_module_text_bg '#{E:@thm_surface_0}'
          set -g @catppuccin_date_time_text ' %Y/%m/%d %H:%M'

          set -g status-left '#{E:@catppuccin_status_session}#[fg=#{E:@thm_surface_0},bg=default] '
          set -g status-right '#{E:@catppuccin_status_date_time}#[fg=#{E:@thm_surface_0},bg=default] '

          set -g @catppuccin_date_time_text '#{l: %Y/%m/%d %H:%M}'
        '';
      }
      cpu
      battery
      tmux-which-key
      extrakto
    ];

    extraConfig = builtins.readFile ./config/tmux.conf;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

}
