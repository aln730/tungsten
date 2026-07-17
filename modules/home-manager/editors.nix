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
    package = pkgs.emacs30-pgtk;
  };

  home.packages = with pkgs; [
    # Doom's install script + runtime deps
    git
    (ripgrep)
    fd
    emacs-lsp-booster
    cmake
    libtool
    gnutls
  ];

  home.file.".config/doom/init.el".source = ../../home/doom/init.el;
  home.file.".config/doom/config.el".source = ../../home/doom/config.el;
  home.file.".config/doom/packages.el".source = ../../home/doom/packages.el;
}
