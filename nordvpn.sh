#!/usr/bin/env bash

script_name=nordvpn

status()
{
    if pidof openvpn>/dev/null
    then
        echo "🌍 OpenVPN is currently running. Use $script_name d to stop"
    else
        echo "🔌 OpenVPN not running."
    fi
}
connect()
{
    if pidof openvpn>/dev/null
    then
        echo "🌍 OpenVPN is already running. Use $script_name d to stop"
        return
    fi
    enable_sudo
    echo "🌍 Starting OpenVPN with $1"
    sudo openvpn $HOME/.config/nordvpn_config/configs/ovpn_udp/$1.nordvpn.com.udp.ovpn >/dev/null &
}
disconnect()
{
    if pidof openvpn>/dev/null
    then
        enable_sudo
        echo "🔌 Stopping OpenVPN"
        sudo pkill openvpn >/dev/null
    else
        echo "🔌 OpenVPN not running!"
    fi
}
recommended_server()
{
    if [[ "$(curl https://nordvpn.com/wp-admin/admin-ajax.php?action=servers_recommendations -s)" =~ \"hostname\":\"([^\\.]*) ]]
    then   
        best=${BASH_REMATCH[1]}
    fi
}
enable_sudo()
{
    if [[ -z $sudo_set ]]
    then
        if [[ "$EUID" = 0 ]]; then
            echo "❌ Do not run as root!"
            exit 1
        else
            sudo -k # make sure to ask for password on next sudo
            if sudo true; then
                echo "✅ correct password"
                sudo_set=true
            else
                echo "⛔ wrong password"
                exit 1
            fi
        fi
    fi
}
download_configs()
{
    echo "🗑️ Removing existing config files..."
    rm -rf $HOME/.config/nordvpn_config/configs
    echo "📁 Creating config directory..."
    mkdir -p $HOME/.config/nordvpn_config/configs
    echo "📥 Downloading configs..."
    wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip -P $HOME/.config/nordvpn_config/
    echo "📦 Unzipping configs..."
    unzip $HOME/.config/nordvpn_config/ovpn.zip -d $HOME/.config/nordvpn_config/configs >/dev/null
    echo "🗑️ Removing zip-file..."
    rm $HOME/.config/nordvpn_config/ovpn.zip
    echo "✍️ Updating configs to use auth file"
    for f in $HOME/.config/nordvpn_config/configs/**/*.ovpn; do echo "auth-user-pass $HOME/.config/nordvpn_config/auth" >> "$f"; done
}
login()
{
    IFS=
    read -p "🔑 Service credentials username: " username
    read -s -p "🔑 Service credentials password: " password
    echo ""
    echo "📁 Creating config directory..."
    mkdir -p $HOME/.config/nordvpn_config/
    echo "🗑️ Removing existing auth file..."
    rm $HOME/.config/nordvpn_config/auth
    echo "✍️ Writing auth file..."
    echo "$username" >$HOME/.config/nordvpn_config/auth
    echo "$password" >>$HOME/.config/nordvpn_config/auth
    echo "🔑 Setting auth file permissions to 400"
    chmod 400 $HOME/.config/nordvpn_config/auth
}
search()
{
    ls -R "$HOME/.config/nordvpn_config/configs/" | grep "$1" | less
}


if [[ -z "$1" ]];
then
    status
    echo ""
    echo "Usage:"
    echo "📥 $script_name download          Downloads the neccessary config files"
    echo "🔑 $script_name login             Create neccessary auth file"
    echo "⚡ $script_name c                 Connects to recommended server"
    echo "🔌 $script_name d                 Disconnects"
    echo "🌍 $script_name <server name>     Connects to server"
    echo "                                      Example: $script_name dk205"
    echo "⭐ $script_name ?                 Get recommended server"
    echo "⭐ $script_name ??                Opens the recommended server page in firefox"
    echo "📈 $script_name s                 Status"
    echo "🔎 $script_name search <keyword>  Search config files"
    echo ""
    echo "Made with ❤️ by Wanieru"
    echo "https://github.com/wanieru/nordvpn-openvpn.sh/"
    exit 0
fi
if [[ $1 = "s" ]];
then
    status
    exit 0
fi
if [[ $1 = "??" ]];
then
    firefox https://nordvpn.com/servers/tools/
    exit 0
fi
if [[ $1 = "?" ]];
then
    recommended_server
    echo $best
    exit 0
fi

if [[ $1 = "d" ]];
then
    disconnect
    exit 0
fi
if [[ $1 = "c" ]];
then
    recommended_server
    connect $best
    exit 0
fi
if [[ $1 = "download" ]];
then
    download_configs
    exit 0
fi
if [[ $1 = "login" ]];
then
    login
    exit 0
fi
if [[ $1 = "search" ]];
then
    search $2
    exit 0
fi

#Assume the argument was the server to connect to
connect $1
