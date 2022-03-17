# SOCKS5 Dante Proxy Docker Image

A compact [Dante](https://www.inet.no/dante/) SOCKS5 proxy Docker image based on
[`bitnami/minideb`](https://hub.docker.com/r/bitnami/minideb) base image.

> Sometimes we all need a way to keep using our favorite apps, even if some unreliable
> group of people dictates us not to.

## Quick Start

Simple as that:

```sh
# Pull (optional)
docker pull aeron/socks5-dante-proxy

# Run
docker run -d --restart always --name dante -p 1080:1080 aeron/socks5-dante-proxy

# Generate
docker run -it --rm --volumes-from dante aeron/socks5-dante-proxy /generate.sh
```

## Usage

This image is available as
[`aeron/socks5-dante-proxy`](https://hub.docker.com/r/aeron/socks5-dante-proxy)
from Docker Hub and
[`ghcr.io/Aeron/socks5-dante-proxy`](https://github.com/Aeron/socks5-dante-proxy/pkgs/container/mongosh)
from GitHub Container Registry. You can use them both interchangeably.

```sh
docker pull aeron/socks5-dante-proxy
# …or…
docker pull ghcr.io/aeron/socks5-dante-proxy
```

### Start a Container

Just run it, like the following:

```sh
docker run -d --restart always --name dante -p 1080:1080 aeron/socks5-dante-proxy
```

### Generate a Password

To be able to authenticate on a running proxy, it’s necessary to generate user password.

```sh
docker run -it --rm --volumes-from dante aeron/socks5-dante-proxy /generate.sh
```

This script can be used any time password change required.

Optionally, it’s possible to save/restore a password by mounting the `/etc/shadow` file.

### Verify a Proxy

To verify everything works correctly, use the following:

```sh
curl --socks5 username:password@host:1080 -L http://ifconfig.me
```

The result must be different from current host’s IP address.

### Use a Custom User Name

In case you need a different user name, it’s still possible to build the image with
`USER` build argument:

```sh
docker build -t aeron/socks5-dante-proxy --build-arg USER=poogie .
```

## IPv6 Support

Docker has IPv6 support out-of-the-box, but it needs to be enabled manually in daemon
configuration and a network created afterward. More on this in the official
[Docker documentation](https://docs.docker.com/config/daemon/ipv6/).
