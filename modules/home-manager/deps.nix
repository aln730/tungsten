{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkg-config
    linux-pam
    openssl
    libfreefare
    libnfc
    libclang
  ];

  programs.zsh.sessionVariables = {
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
    LIBFREEFARE_PATH = "${pkgs.libfreefare}/lib";
    LIBNFC_PATH = "${pkgs.libnfc}/lib";
  };
}
