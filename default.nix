{ pkgs ? import <nixpkgs> { }
, mkDerivation ? pkgs.stdenv.mkDerivation
, makeWrapper ? pkgs.makeWrapper
, lib ? pkgs.lib
, unzip ? pkgs.unzip
, wget ? pkgs.wget
, openvpn ? pkgs.openvpn
, ...
}:
pkgs.stdenv.mkDerivation {
  name = "nordvpn";
  src = ./.;

  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ unzip wget openvpn ];

  installPhase = ''
    mkdir -p $out/bin
    cp nordvpn.sh $out/bin/.nordvpn-wrapped
    makeWrapper $out/bin/.nordvpn-wrapped $out/bin/nordvpn --prefix PATH : ${lib.makeBinPath [ unzip wget openvpn ]}
  '';
}
