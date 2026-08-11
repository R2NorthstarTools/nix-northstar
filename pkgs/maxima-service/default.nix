{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  pkgsBuildHost,
  autoPatchelfHook,
  makeBinaryWrapper,
  toolchain ? pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml,
}:
(rustPlatform.buildRustPackage.override { rustc = toolchain; }) (finalAttrs: {
  pname = "maxima-service";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "catornot";
    repo = "Maxima";
    rev = "9e1adf40111733f1f72dae2b88ccf64d4b95bd28";
    hash = "sha256-VkWdFW9uc/pOodO/HpGilEZhKs17MNM35dlY+p7OTUA=";
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
    makeBinaryWrapper
  ];

  buildInputs = [
    protobuf
    pkg-config
  ];

  cargoBuildFlags = [
    "--package"
    finalAttrs.pname
  ];

  checkFlags = [
    # doesn't work on linux maybe?? nah probably needs network access
    "--skip=cloudsync"
  ];

  postInstall = ''
    chmod +w $out/bin/maxima-service

    wrapProgram $out/bin/maxima-service --prefix MAXIMA_PACKAGED : 1
  '';

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
    mainProgram = finalAttrs.pname;
  };
})
