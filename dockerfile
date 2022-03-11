FROM bitnami/minideb:bullseye

LABEL org.opencontainers.image.source https://github.com/Aeron/socks5-dante-proxy
LABEL org.opencontainers.image.licenses MIT

RUN install_packages \
    dante-server \
    openssl \
    curl

ARG USER=socks

ENV WORKERS 4
ENV CONFIG /etc/sockd.conf

COPY etc/passwd /etc/passwd
COPY etc/passwd /etc/shadow
COPY etc/group /etc/group

COPY dante.conf ${CONFIG}
COPY generate.sh .

RUN adduser --system --no-create-home ${USER}

VOLUME /etc
EXPOSE 1080

CMD danted -N ${WORKERS} -f ${CONFIG}
