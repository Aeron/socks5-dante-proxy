# SOCKS5 Dante Proxy @ Docker

An easy way to deploy [Dante](https://www.inet.no/dante/)-based SOCKS5 proxy on own server using Docker.

> Sometimes we all need a way to keep using our favorite apps, even if some unreliable group of people dictates us not to.

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

### Get an Image

An image can be pulled from a [registry](https://hub.docker.com/r/aeron/socks5-dante-proxy/) or, in case you have a reason to do so, built manually.

#### Pull an Image

**This action is optional**, since [the first run](#start-a-container) will perform it automatically.

```sh
docker pull aeron/socks5-dante-proxy
```

#### Build an Image

Build it, like usually:

```sh
docker build -t aeron/socks5-dante-proxy .
```

To alter username, simply use build argument `USER`:

```sh
docker build -t aeron/socks5-dante-proxy --build-arg USER=poogie .
```

Also it’s possible to generate user password during image build, by using `GEN` argument:

```sh
docker build -t aeron/socks5-dante-proxy --build-arg GEN=true .
```

### Start a Container

Just run it, like the following:

```sh
docker run -d --restart always --name dante -p 1080:1080 aeron/socks5-dante-proxy
```

### Generate a Password

To be able to authenticate on a running proxy, it’s necessary to generate user password. In case it wasn’t made already during image build.

```sh
docker run -it --rm --volumes-from dante aeron/socks5-dante-proxy /generate.sh
```

This script can be used any time password change required.

### Verify a Proxy

To verify everything works correctly, use the following:

```sh
curl --socks5 username:password@host:1080 -L http://ifconfig.me
```

The result must be different from current host’s IP address.
