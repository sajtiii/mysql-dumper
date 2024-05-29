FROM alpine

RUN apk add --no-cache \
    bash \
    mysql-client \
    mariadb-connector-c \
    rdiff-backup \
    rclone

ADD overlay/ /

RUN chmod +x /entrypoint.sh && \
    chmod +x /dumper.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "" ]