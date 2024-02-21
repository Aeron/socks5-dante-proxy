FROM docker.io/bitnami/minideb:bookworm

LABEL org.opencontainers.image.source https://github.com/Aeron/socks5-dante-proxy
LABEL org.opencontainers.image.licenses MIT

RUN install_packages \
    dante-server \
    openssl \
    curl

WORKDIR /srv
COPY . .

RUN echo 'root:x:0:' > /etc/group && \
    echo 'nogroup:x:65534:' >> /etc/group
RUN echo 'root:*:17885:0:99999:7:::' > /etc/shadow && \
    echo 'nobody:*:17885:0:99999:7:::' >> /etc/shadow
RUN echo 'root:x:0:0:root:/root:/bin/bash' > /etc/passwd && \
    echo 'nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin' >> /etc/passwd

ENV WORKERS 4
ENV CONFIG /etc/sockd.conf

RUN ln -sf /srv/dante.conf "${CONFIG}"

VOLUME /etc
EXPOSE 1080

ENTRYPOINT [ "/srv/entrypoint.sh" ]
CMD [ "start" ]
