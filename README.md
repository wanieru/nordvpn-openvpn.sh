# nordvpn-openvpn.sh
Make it easy to use NordVPN with OpenVPN. Bash script to download nordvpn configs, authenticating and connecting/disconnecting from recommended servers.

# Install
### Regular
1. Make sure you have "openvpn", "unzip" and "wget" in your path.
2. Download the "nordvpn.sh" to your path, call it "nordvpn"

### NixOS
1. Add the following to your config
```nix
users.users.<your username>.packages = 
[
  (import (fetchTarball https://github.com/wanieru/nordvpn-openvpn.sh/archive/main.tar.gz) { inherit pkgs; })
];
```

# How to use
### First time use
1. `nordvpn download` - Downloads all NordVPN's config files to ~/.config/nordvpn_config/ and modifies them to use the authentication file at ~/.config/nordvpn_config/auth
2. `nordvpn login` - Asks for service login (username and password), which is stored in the auth file.

### Connecting and disconnecting
1. `nordvpn` - Prints help text
2. `nordvpn c` - Automatically fetches the current recommended server and connects to it.
3. `nordvpn d` - Disconnects from OpenVPN.
4. `nordvpn s` - Shows current OpenVPN status
 
### Special use
1. `nordvpn <server>` - connects to a specfic server. For example: "nordvpn dk205"
2. `nordvpn ?` - prints the current recommended server
3. `nordvpn ??` - opens the nordvpn "recommended server" web page in firefox.
4. `nordvpn search <keyword>` - searches among the config files for the specified keywords. For example: "nordvpn search jp"

# Contribute
Feel free to make pull requests to improve the script :)
