{
  pkgs,
  lib,
  ...
}:
let
  nixpkgs-source = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "1c6e20d41d6a9c1d737945962160e8571df55daa";
    hash = "sha256-GIMyMt1pkkoXdCq9un859bX6YQZ/iYtukb9R5luazLM=";
  };
  system = pkgs.stdenv.hostPlatform.system;
in
let
  pkgs = import nixpkgs-source { inherit system; };
in
pkgs.stdenv.mkDerivation rec {
  pname = "MRVN-Radiant";
  version = "0.1.9";

  src = pkgs.fetchgit {
    url = "https://github.com/${pname}/${pname}.git";
    rev = "cdd17d8a6966162fa5e326706ad4e9a3d7964fac";
    sha256 = "sha256-bzSOE/ueOftQerXS05MI9/1bxhOdWi3I1yGleCjM4hw=";
  };

  # nativeBuildInputs = with pkgs; [
  #   cmake
  #   copyDesktopItems
  #   pkg-config
  #   patchelf
  #   keepBuildTree # HACK
  #   libsForQt5.wrapQtAppsHook
  # ];

  # buildInputs = with pkgs; [
  #   libsForQt5.qt5.qtbase
  #   glib
  #   libxml2
  #   zlib
  #   libpng
  #   libjpeg
  #   libxcb
  #   libGL
  #   wayland
  # ];

  nativeBuildInputs = with pkgs; [
    copyDesktopItems
    cmake
    pkg-config
    keepBuildTree # HACK: otherwise nix will complain about rpath linking to /build/
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    pcre
    libsysprof-capture

    qt5.qtbase

    glib
    libxml2
    zlib
    libpng
    libjpeg

    wayland

    libxkbcommon

    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXi
    xorg.libXcursor
    xorg.libxcb
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=format-security"
  ];

  postPatch = ''
    mkdir -p $out/bin
    cp -r install/* $out/bin
  '';
  postInstall = ''
    mkdir -p $out/bin
    cp -r ../install/* $out/bin
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cmake --install . --prefix $out
    runHook postInstall
  '';

  cmakeFlags = [
    "-DBUILD_TOOLS=ON"
    "-DBUILD_RADIANT=ON"
    "-DBUILD_PLUGINS=ON"
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      desktopName = pname;
      name = pname;
      exec = meta.mainProgram;
      icon = "${src}/icons/radiant-src.png";
      type = "Application";
      comment = meta.description;
      terminal = false;
      categories = [ "Development" ];
      keywords = [
        "3D"
      ];
    })
  ];

  meta = {
    description = "MRVN-Radiant is a fork of netradiant-custom modified for Titanfall and Apex Legends mapping.";
    homepage = "https://github.com/MRVN-Radiant/MRVN-Radiant";
    license = with lib.licenses; [
      lgpl21
      bsd0
      gpl2
    ];
    mainProgram = "radiant";
  };
}
