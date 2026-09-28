# Space Grotesk isn't in nixpkgs; fetch the upstream prebuilt OTF release
# directly (pinned zip, immutable GitHub release asset).
{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "space-grotesk";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/floriankarsten/space-grotesk/releases/download/${version}/SpaceGrotesk-${version}.zip";
    hash = "sha256-niwd5E3rJdGmoyIFdNcK5M9A9P2rCbpsyZCl7CDv7I8=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 "$src/SpaceGrotesk-${version}/otf/"*.otf -t "$out/share/fonts/opentype"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Proportional sans-serif typeface by Florian Karsten";
    homepage = "https://github.com/floriankarsten/space-grotesk";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
