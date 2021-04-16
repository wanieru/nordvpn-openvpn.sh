{pkgs, ...}:
pkgs.writeShellScriptBin "nordvpn" "${builtins.readFile ./nordvpn.sh}"
