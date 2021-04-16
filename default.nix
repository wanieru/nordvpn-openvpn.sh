{ pkgs ? import <nixpkgs> { }
, mkDerivation ? pkgs.stdenv.mkDerivation
, unzip ? pkgs.unzip
, wget ? pkgs.wget
, openvpn ? pkgs.openvpn
, ...
}:
pkgs.stdenv.mkDerivation {
  name = "nordvpn";
  src = ./.;

  nativeBuildInputs = [ unzip wget openvpn ];

  installPhase = ''
    mkdir -p $out/bin
    mv nordvpn.sh $out/bin/
    chmod +x $out/bin/nordvpn.sh
  '';
}
