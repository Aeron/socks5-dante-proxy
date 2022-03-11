#!/bin/sh
USER=$(getent passwd | tail -1 | grep -oE "^([a-zA-Z0-9._]+)")
PASS=$(openssl rand -base64 16)
HOST=$(curl -s http://whatismyip.akamai.com/)

echo "$USER:$PASS" | chpasswd

echo -n "\033[0;36m"
echo "Server: $HOST:1080"
echo "Username: $USER"
echo "Password: $PASS"
echo -n "\033[0m"

echo -n "\033[0;33m"
echo "Test it using the following:"
echo "curl --socks5 $USER:$PASS@$HOST:1080 \\"
echo "    -L http://ifconfig.me"
echo -n "\033[0m"
