{ config, pkgs, inputs, ... }:

let
  ghqRepo = pkgs.writeScriptBin "ghq-repo" (builtins.readFile ./bin/ghq-repo.sh);
in 
{
  home.username = "aki543";
  home.homeDirectory = "/home/aki543";
  home.stateVersion = "24.11";
  home.sessionVariables = {
    _ZO_EXCLUDE_DIRS = "$HOME/.ghq";
    FZF_DEFAULT_OPTS="--layout=reverse --height=45% --border --preview-window=down:30%";
  };

  xdg.configFile."oh-my-posh".source = "${inputs.dotfiles}/.config/ohmyposh";
  xdg.configFile."nvim".source = "${inputs.dotfiles}/.config/nvim";

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git = {
    enable = true;
    userName = "aki543-APC";
    userEmail = "a_maruyama@ap-com.co.jp";

    extraConfig = {
      pull.rebase = true;
      rerere.enabled = true;
      init.defaultBranch = "main";
      color.ui = "auto";
      core.editor = "nvim";
      merge.conflictsytyle = "zdiff3";
      ghq.root = "/home/aki543/.ghq";

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        sw = "switch";
      };
    };
  };

  programs.zsh = {
    enable = true;

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
    };
    initContent = ''
      eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.omp.json)"
    '';

  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [ gcc gnumake ];
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = catppuccin;
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

    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    eza
    oh-my-posh
    curl
    fzf
    gh
    ghq
    ghqRepo
  ];
}
