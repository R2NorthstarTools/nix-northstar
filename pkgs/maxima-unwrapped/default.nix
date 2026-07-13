{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkgsBuildHost,
  libxkbcommon,
  vulkan-loader,
  libx11,
  libxcursor,
  libxrandr,
  xinput,
  wayland,
  pkg-config,
  expat,
  fontconfig,
  freetype,
  libGL,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  toolchain ? pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml,
  python314,
  umu-launcher,
}:
(rustPlatform.buildRustPackage.override { rustc = toolchain; }) (finalAttrs: {
  pname = "maxima-unwrapped";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "catornot";
    repo = finalAttrs.pname;
    rev = "ecf7860c838f9049f16b20fd4577e1c85a2b9604";
    hash = "sha256-giTGRsL9QiN1Yn/x6ZWTXjJ1lM7So9V0+hk/AUw+XM8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async-compression-0.4.5" = "sha256-6PRxfc//AsTJ8MMN3bql3kaNs+jLS7rkmRVJj1Tke0M=";
      "flate2-1.0.28" = "sha256-j6T/3yNxefDFi6yyPVi0D0hcvRsLz7EJ/Nypf4WRFvA=";
    };
  };

  nativeBuildInputs = [
    toolchain
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    protobuf
    pkg-config
    expat
    fontconfig
    freetype
    freetype.dev
    libGL
    libx11
    libxcursor
    xinput
    libxrandr
    wayland
    libxkbcommon
  ];

  checkFlags = [
    # doesn't work on linux maybe?? nah probably needs network access
    "--skip=cloudsync"
  ];

  runtimeDependencies = [
    expat
    fontconfig
    freetype
    freetype.dev
    libGL
    libx11
    libxcursor
    xinput
    libxrandr
    wayland
    libxkbcommon
  ];

  LD_LIBRARY_PATH = builtins.foldl' (
    a: b: "${a}:${b}/lib"
  ) "${vulkan-loader}/lib" finalAttrs.runtimeDependencies;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
    export PROTOC=${lib.getExe' protobuf "protoc"} 
  '';

  meta = {
    description = "A free and open-source replacement for the EA Desktop Launcher for Linux and Windows.";
    homepage = "https://github.com/ArmchairDevelopers/Maxima";
    license = with lib.licenses; [
      gpl3
    ];
    mainProgram = "maxima";
  };
})
