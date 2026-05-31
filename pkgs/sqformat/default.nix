{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sqformat";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Bobbyperson";
    repo = finalAttrs.pname;
    tag = "v" + finalAttrs.version;
    hash = "sha256-PomMSPhS+LJ60KaRR2B8jX4cYnl2RTO18bF3rd2NdpI=";
  };

  cargoHash = "sha256-UfoNMBvUQ3Y4xTAZqdqj2sIyWP3wz1BgBnyKpaBnojI=";

  meta = {
    description = "Formatter for respawn's version of squirrel";
    homepage = "https://github.com/Bobbyperson/sqformat";
    license = with lib.licenses; [
      mit
    ];
    mainProgram = "sqformat";
  };
})
