{
  lib,
  clangStdenv,
  stdenv,
  fetchFromGitHub,
  lld,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  ...
}:
let
  dxvk-native = stdenv.mkDerivation (finalAttrs: {
    pname = "dxvk-native";
    version = "2.7.1";

    src = fetchTarball {
      url = "https://github.com/doitsujin/dxvk/releases/download/v${finalAttrs.version}/dxvk-native-${finalAttrs.version}-steamrt-sniper.tar.gz";
      sha256 = "sha256:0y7fg1pggychscgmw5j7vw1sckl8z2sz2vb1x4jgnj4sknqdmnmw";
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
      mv $out/include/dxvk/* $out/include
      rmdir $out/include/dxvk
    '';
  });
in
clangStdenv.mkDerivation {
  pname = "RePak";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "catornot";
    repo = "RePak";
    rev = "69d257915902639782e729f4881e85aeb1f362bb";
    hash = "sha256-mPuLgeOFDQxJs3d7UWrRhfJnlCOcZilDERhJrFSB7I8=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    lld
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dxvk-native
  ];

  installPhase = "";

  meta = {
    description = "Tool for compiling and combining asset data into Respawn Entertainment's RPAK format for Titanfall 2 and Apex Legends";
    platforms = lib.platforms.unix;
  };
}
