# modules/home-manager/shell.nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    jq
    curl
    wget
    unzip
    zip
    tree
    htop
    btop
    nerd-fonts.jetbrains-mono
    fastfetch
    nerd-fonts.symbols-only
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -l --icons --git";
      la = "eza -la --icons --git";
      lt = "eza --tree --icons";
      cat = "bat";
      c = "clear";
      z = "fastfetch";
      ncd = "cd /etc/nixos";
      nw = "sudo nixos-rebuild switch --flake .#tungsten";
      e = "emacs";
      vpn = "printurl-client-electron";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = "$directory$git_branch$git_status$character";
      right_format = "$cmd_duration";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      directory = {
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "yellow";
      };

      cmd_duration = {
        min_time = 500;
        format = "took [$duration](yellow)";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.bat.enable = true;

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git"
    ];
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 0;
    baseIndex = 1;
    mouse = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
    window = {
      opacity = 0.75;
      padding = {
        x = 8;
        y = 8;
      };
    };
    font = {
      normal.family = "JetBrainsMono Nerd Font";
      size = 12;
      };
    };
  };

  programs.alacritty.settings.terminal.shell = {
    program = "tmux";
    args = [ "new-session" "-A" "-s" "main" ];
  };
}
