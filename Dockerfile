FROM alpine:3.19.1

# Install required packages
RUN apk add -U \
        bash \
        curl \
        inotify-tools \
        netcat-openbsd \
        net-tools \
        wget \
        sox \
        libogg \
        libvorbis \
        asterisk \
        asterisk-sample-config

# Copy scripts
COPY scripts/ /
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Copy asterisk configuration
#COPY conf/* /etc/asterisk/

# Run the entrypoint script
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Run the inotify-script
CMD [ "inotify-script" ]
