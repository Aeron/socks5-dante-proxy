# Builder stage
FROM docker.io/bitnami/minideb:trixie AS build

ARG DANTE_VERSION=1.4.4
ARG DANTE_URL="https://www.inet.no/dante/files/dante-${DANTE_VERSION}.tar.gz"
ARG DANTE_SHA256="1973c7732f1f9f0a4c0ccf2c1ce462c7c25060b25643ea90f9b98f53a813faec"

RUN install_packages \
    build-essential \
    ca-certificates \
    curl

WORKDIR /src

RUN curl -fsSL "$DANTE_URL" -o /tmp/dante.tar.gz \
    && echo "${DANTE_SHA256} /tmp/dante.tar.gz" | sha256sum -c - \
    && tar xzf /tmp/dante.tar.gz --strip-components=1 -C /src

RUN ./configure CFLAGS="-O2" --sysconfdir=/etc --without-upnp --without-libwrap \
    && make -j"$(nproc)" \
    && make install DESTDIR=/out

# Runtime stage
FROM docker.io/bitnami/minideb:trixie AS runtime

LABEL org.opencontainers.image.source="https://github.com/Aeron/socks5-dante-proxy"
LABEL org.opencontainers.image.licenses="MIT"

RUN install_packages \
    openssl \
    curl

COPY --from=build /out/ /

WORKDIR /srv
COPY . .

RUN echo 'root:x:0:' > /etc/group && \
    echo 'nogroup:x:65534:' >> /etc/group
RUN echo 'root:*:17885:0:99999:7:::' > /etc/shadow && \
    echo 'nobody:*:17885:0:99999:7:::' >> /etc/shadow
RUN echo 'root:x:0:0:root:/root:/bin/bash' > /etc/passwd && \
    echo 'nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin' >> /etc/passwd

ENV WORKERS=4
ENV CONFIG=/etc/sockd.conf

RUN ln -sf /srv/dante.conf "${CONFIG}"

VOLUME /etc
EXPOSE 1080

ENTRYPOINT [ "/srv/entrypoint.sh" ]
CMD [ "start" ]
