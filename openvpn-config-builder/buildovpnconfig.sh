#!/bin/bash

EASYRSA_PATH="/etc/openvpn/easy-rsa/2.0"
OPENVPNCLIENT_PATH="/root/openvpn/clients"
OPENVPN_PORT="1194"
OPENVPN_REMOTE="kzn-ovpn.massopen.cloud"

abort() {
        echo $1;
        exit 1;
}

username=$1

mkdir -p "$OPENVPNCLIENT_PATH/.tmp"

addtofile() {
        echo $1 >> "$OPENVPNCLIENT_PATH/.tmp/${username}.conf"
}

## Init process
if [ -z "$username" ]
then
        abort "You must provide the name for the client"
fi

cd $EASYRSA_PATH
if [ -s ./pkitool ]
then
        echo "Generating keys and certs for user ${username}"
        source vars
        ./pkitool $1
        echo "Done"
else
        abort "pkitool script not found"
fi

echo "Preparing .conf file..."
addtofile "remote $OPENVPN_REMOTE $OPENVPN_PORT"
addtofile "client"
addtofile "dev tun"
addtofile "proto udp"

# Keep trying indefinitely to resolve the host name of the OpenVPN server.
# Very useful on machines which are not permanently connected to the internet
# such as laptops.
addtofile "resolv-retry infinite"

# Most clients don't need to bind to a specific local port number.
addtofile "nobind"

# Try to preserve some state across restarts. persist-tun can be enabled.
addtofile "persist-key"
#addtofile "persist-tun"

addtofile "remote-cert-tls server"
addtofile "float"
addtofile "hand-window 120"
addtofile "auth-nocache"

# Enable compression if it's enabled on the server side.
#addtofile "comp-lzo"

# Set log file verbosity
#addtofile "verb 3"

# Adding ca certificate to.conf client configuration file
echo "Adding ca certificate to.conf client configuration file"
addtofile "<ca>" >> "$OPENVPNCLIENT_PATH"/.tmp/${username}.conf
cat "$EASYRSA_PATH"/keys/ca.crt | grep -A 100 "BEGIN CERTIFICATE" | grep -B 100 "END CERTIFICATE" >> "$OPENVPNCLIENT_PATH"/.tmp/${username}.conf
addtofile "</ca>"
echo "Done"

# Adding user certificate to.conf client configuration file
echo "Adding user certificate to.conf client configuration file"
addtofile "<cert>"
cat "$EASYRSA_PATH"/keys/${username}.crt | grep -A 100 "BEGIN CERTIFICATE" | grep -B 100 "END CERTIFICATE" >> "$OPENVPNCLIENT_PATH"/.tmp/${username}.conf
addtofile "</cert>"
echo "Done"

# Adding user key to.conf client configuration file
echo "Adding user key to.conf client configuration file"
addtofile "<key>"
cat "$EASYRSA_PATH"/keys/${username}.key | grep -A 100 "BEGIN PRIVATE KEY" | grep -B 100 "END PRIVATE KEY" >> "$OPENVPNCLIENT_PATH"/.tmp/${username}.conf
addtofile "</key>"

mkdir -p "$OPENVPNCLIENT_PATH"/${username}
mv "$OPENVPNCLIENT_PATH"/.tmp/${username}.conf "$OPENVPNCLIENT_PATH"/${username}/${username}.conf
echo "Done"

exit 0
