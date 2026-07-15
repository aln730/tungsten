{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkg-config
    linux-pam
    openssl
    openssl.dev
    libfreefare
    libnfc
    libclang
  ];

  programs.zsh.sessionVariables = {
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
    LIBFREEFARE_PATH = "${pkgs.libfreefare}/lib";
    LIBNFC_PATH = "${pkgs.libnfc}/lib";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
