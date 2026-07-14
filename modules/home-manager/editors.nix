{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
    };
    extraConfig = ''
      set incsearch
      set ignorecase
      set smartcase
      set clipboard=unnamedplus
    '';
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };
}
