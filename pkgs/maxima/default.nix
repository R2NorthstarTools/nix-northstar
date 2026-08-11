{
  maxima-unwrapped,
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  python314,
  umu-launcher,

  expat,
  fontconfig,
  freetype,
  libGL,
  libx11,
  libxcursor,
  xinput,
  libxrandr,
  wayland,
  libxkbcommon,
  vulkan-loader,
}:
symlinkJoin (finalAttrs: {
  pname = "maxima";
  version = "0.0.0";

  paths = [ maxima-unwrapped ];

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
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
    vulkan-loader
  ];

  LD_LIBRARY_PATH = builtins.foldl' (
    a: b: "${a}:${b}/lib"
  ) "${vulkan-loader}/lib" finalAttrs.runtimeDependencies;

  desktopItems = [
    (makeDesktopItem {
      desktopName = finalAttrs.pname;
      name = finalAttrs.pname;
      exec = finalAttrs.meta.mainProgram;
      icon = "${maxima-unwrapped.src}/maxima-resources/assets/logo.ico";
      type = "Application";
      comment = finalAttrs.meta.description;
      terminal = false;
      categories = [ "Application" ];
      keywords = [
      ];
    })
    (makeDesktopItem {
      desktopName = "maxima-qrc";
      name = "maxima-qrc";
      exec = "maxima-bootstrap";
      icon = "${maxima-unwrapped.src}/maxima-resources/assets/logo.ico";
      type = "Application";
      comment = finalAttrs.meta.description;
      terminal = false;
      categories = [ "Application" ];
      keywords = [
      ];
      noDisplay = true;
      mimeTypes = [ "x-scheme-handler/qrc" ];
    })
  ];

  postBuild = ''
    copyDesktopItems

    rm $out/bin/maxima
    cp ${maxima-unwrapped}/bin/maxima $out/bin/maxima
    chmod +w $out/bin/maxima

    rm $out/bin/maxima-cli
    cp ${maxima-unwrapped}/bin/maxima-cli $out/bin/maxima-cli
    chmod +w $out/bin/maxima-cli

    wrapProgram $out/bin/maxima --prefix LD_LIBRARY_PATH : ${finalAttrs.LD_LIBRARY_PATH} --prefix PATH : ${
      lib.makeBinPath [
        umu-launcher
        python314.out
      ]
    } --prefix MAXIMA_WINE_COMMAND : umu-run --prefix MAXIMA_PACKAGED : 1
    wrapProgram $out/bin/maxima-cli --prefix LD_LIBRARY_PATH : ${finalAttrs.LD_LIBRARY_PATH} --prefix PATH : ${
      lib.makeBinPath [
        umu-launcher
        python314.out
      ]
    } --prefix MAXIMA_WINE_COMMAND : umu-run --prefix MAXIMA_PACKAGED : 1
  '';

  meta = maxima-unwrapped.meta;
})
