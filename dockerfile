FROM alpine

COPY etc/passwd /etc/passwd
COPY etc/passwd /etc/shadow
COPY etc/group /etc/group

ARG REPO=http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN apk add --no-cache -X ${REPO} \
    dante-server openssl curl

ENV WORKERS 4
ENV CONFIG /etc/sockd.conf

COPY dante.conf ${CONFIG}
COPY generate.sh .

ARG USER=socks
ARG GEN=false

RUN adduser -SDH ${USER}
RUN [ ${GEN} = false ] || ./generate.sh

VOLUME /etc
EXPOSE 1080

CMD sockd -N ${WORKERS} -f ${CONFIG}
