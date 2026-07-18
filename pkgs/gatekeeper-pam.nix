{
  rustPlatform,
  pkg-config,
  linux-pam,
  openssl,
  libfreefare,
  libnfc,
  libclang,
  inputs,
}:

rustPlatform.buildRustPackage {
  pname = "gatekeeper-pam";
  version = "1.0-beta";
  src = inputs.gatekeeper-pam;
  cargoLock.lockFile = "${inputs.gatekeeper-pam}/Cargo.lock";

  nativeBuildInputs = [
    pkg-config
    libclang
  ];
  buildInputs = [
    linux-pam
    openssl
    libfreefare
    libnfc
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-I${linux-pam}/include";
  LIBFREEFARE_PATH = "${libfreefare}/lib";
  LIBNFC_PATH = "${libnfc}/lib";

  postInstall = ''
    mkdir -p $out/lib/security
    mv $out/lib/libgatekeeper_pam.so $out/lib/security/pam_gatekeeper.so
  '';
}
