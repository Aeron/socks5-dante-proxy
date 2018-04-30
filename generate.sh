#!/bin/sh
USER=$(getent passwd | tail -1 | grep -oE "^([a-zA-Z0-9._]+)")
PASS=$(openssl rand -base64 16)
HOST=$(curl -s http://whatismyip.akamai.com/)

echo "$USER:$PASS" | chpasswd

echo -e "\033[0;36mServer: $HOST:1080\nUsername: $USER\nPassword: $PASS\033[0m"
echo -e "\033[0;33mTest it using the following:\ncurl --socks5 $USER:$PASS@$HOST:1080 -L http://ifconfig.me\033[0m"
