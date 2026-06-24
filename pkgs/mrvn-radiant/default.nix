{
  lib,
  fetchgit,
  makeDesktopItem,
  # libs
  pcre,
  libsysprof-capture,
  qt6,
  libGL,
  mesa,
  wayland,
  glib,
  libxml2,
  zlib,
  libpng,
  libjpeg,
  libxkbcommon,
  libx11,
  libxext,
  libxrender,
  libxi,
  libxcursor,
  libxcb,
  # stuff to compile mrvn
  makeWrapper,
  copyDesktopItems,
  cmake,
  pkg-config,
  keepBuildTree,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = "MRVN-Radiant";
  version = "0.1.9";

  src = fetchgit {
    url = "https://github.com/RoyalBlue1/${pname}.git";
    rev = "0e0a7d7138f0e66823d967bbff750a3c4aee3649";
    sha256 = "sha256-mvlAR31zHRZAC6FipDu41Adv73t18zCGLF4+vv/CdvA=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    cmake
    pkg-config
    keepBuildTree # HACK: otherwise nix will complain about rpath linking to /build/ # TODO: fix this
    makeWrapper
  ];

  buildInputs = [
    pcre
    libsysprof-capture

    qt6.qtbase.dev

    libGL
    mesa

    wayland

    glib
    libxml2
    zlib
    libpng
    libjpeg

    libxkbcommon

    libx11
    libxext
    libxrender
    libxi
    libxcursor
    libxcb
  ];

  dontWrapQtApps = true;

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

  postFixup = ''
    wrapProgram $out/bin/radiant \
      --set QT_QPA_PLATFORM_PLUGIN_PATH \
      "${qt6.qtbase}/lib/qt-${qt6.qtbase.version}/plugins/platforms"
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = pname;
      name = pname;
      exec = meta.mainProgram;
      icon = "${src}/icons/radiant.ico";
      type = "Application";
      comment = meta.description;
      terminal = false;
      categories = [ "Development" ];
      keywords = [
        "3D"
        "Radiant"
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
