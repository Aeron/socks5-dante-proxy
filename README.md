# SOCKS5 Dante Proxy Container Image

A compact [Dante](https://www.inet.no/dante/) SOCKS5 proxy container image based on
[`bitnami/minideb`](https://hub.docker.com/r/bitnami/minideb) base image.

> Sometimes, we all need a way to keep using our favorite apps, even if some unreliable
> group of people dictates us not to.

## Usage

The container image is available as [`docker.io/aeron/socks5-dante-docker`][docker] and
[`ghcr.io/Aeron/socks5-dante-docker`][github]. You can use both interchangeably.

```sh
docker pull docker.io/aeron/socks5-dante-docker
# …or…
docker pull ghcr.io/aeron/socks5-dante-docker
```

[docker]: https://hub.docker.com/r/aeron/socks5-dante-docker
[github]: https://github.com/Aeron/socks5-dante-proxy/pkgs/container/socks5-dante-proxy

### Container Running

Running a container is pretty straightforward:

```sh
docker -d --restart unless-stopped --name dante \
    -p 1080/1080:tcp \
    -e WORKERS=4 \
    -e CONFIG=/etc/sockd.conf \
    docker.io/aeron/socks5-dante-docker:latest
```

By default, the number of simultaneous workers (the `WORKERS` environment variable)
is `4`. Adjust it to host CPU capabilities if necessary.

In the case of a custom configuration file, use the `CONFIG` variable to specify a path.
By default, it is always the `/etc/sockd.conf` (a symbolic link to the `/srv/dante.conf`
).

But you’ll need to [add a new user](#user-management) first.

### Entrypoint Options

The entry point script supports the following commands and parameters:

```text
Usage: /entrypoint.sh [COMMAND [PARAMS..]]

Commands:
    add-user NAME [PASS]    Add a new user
    del-user NAME           Delete an existing user
    start                   Start the dante server
                            [container command]

Parameters:
    NAME                    A username
                            [default: "socks"]
```

### User Management

To authenticate on a running proxy, you must add a user:

```sh
docker run -it --rm --volumes-from dante \
    aeron/socks5-dante-proxy:latest \
    add-user [NAME [PASS]]
# or
docker exec -it dante /srv/entrypoint.sh add-user [NAME [PASS]]
```

The `NAME` parameter is always optional, so you can omit it and use the default one.
But if the `PASS` is empty, the script will generate a new password.

To delete a user, use an appropriate command:

```sh
docker run -it --rm --volumes-from dante \
    aeron/socks5-dante-proxy:latest \
    del-user [NAME]
# or
docker exec -it dante /srv/entrypoint.sh del-user [NAME]
```

### Data Persistency

To save or restore existing users, mount `/etc/passwd` and `/etc/shadow` files:

```sh
docker -d --restart unless-stopped --name dante \
    -p 1080/1080:tcp \
    -v /path/to/passwd:/etc/passwd:rw \
    -v /path/to/shadow:/etc/shadow:rw \
    docker.io/aeron/socks5-dante-docker:latest
```

Replace the `/path/to/passwd` and `/path/to/shadow` with preferred file paths.

### Proxy Verification

To verify that everything works correctly, use the following:

```sh
curl --socks5 username:password@host:1080 -L http://ifconfig.co
```

The result must be different from your current IP address.

## IPv6 Support

Docker has IPv6 support out-of-the-box, but it needs to be enabled manually in daemon
configuration and a network created afterward.  You can learn more about this in the
official [Docker documentation][ipv6-docs].

[ipv6-docs]: https://docs.docker.com/config/daemon/ipv6/
