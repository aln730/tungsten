{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkg-config
    clang
    linux-pam
    openssl
    libfreefare
    libnfc
  ];

  programs.zsh.sessionVariables = {
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
  };
}
