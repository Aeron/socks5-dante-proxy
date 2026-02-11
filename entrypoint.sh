#!/bin/sh

_strip_name() {
    echo "$1" | tr '@&+.:' '-' | tr -d '=!%^#$\/()[]{}|;<>, ' | xargs
}

set -- "$1" "$(_strip_name "$2")" "$3"
if [ -z "$2" ]; then
    set -- "$1" 'socks' "$3"
fi

# shellcheck disable=SC2016
HELP='Usage: /entrypoint.sh [COMMAND [PARAMS..]]

Commands:
    add-user NAME [PASS]    Add a new user
    del-user NAME           Delete an existing user
    start                   Start the dante server
                            [container command]

Parameters:
    NAME                    A username
                            [default: "socks"]
'

case "$1" in
    'add-user')
        USER="$2"
        PASS=$(echo "$3" | xargs)
        if [ -z "$PASS" ]; then
            PASS=$(openssl rand -base64 16)
        fi

        adduser --quiet --system --no-create-home "$USER"
        echo "$USER:$PASS" | chpasswd

        URL="http://ifconfig.co"
        HOST=$(curl -s "$URL")

        echo 'SOCKS5 connection parameters:'
        echo "- Server:   $HOST:1080"
        echo "- Username: $USER"
        echo "- Password: $PASS"
        echo
        echo 'Test it using the following command:'
        echo "curl --socks5 $USER:$PASS@$HOST:1080 -L $URL"
        ;;
    'del-user')
        deluser --quiet --system "$2" 2> /dev/null
        ;;
    'start')
        sockd -N "$WORKERS" -f "$CONFIG"
        ;;
    *)
        echo "$HELP"
        ;;
esac
