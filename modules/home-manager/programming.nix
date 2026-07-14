{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    gcc
    python3
    go
    nodejs
    nodePackages.npm
  ];

  programs.zsh.sessionVariables = {
    GOPATH = "$HOME/go";
    PATH = "$HOME/go/bin:$HOME/.cargo/bin:$PATH";
  };
}
