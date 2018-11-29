FROM debian:9

RUN apt-get -qq update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install\
    build-essential \
    ca-certificates \
    openssh-client \
    curl \
    git \
    dnsutils &&\
    # Docker install
    curl -sSL https://get.docker.com | sh &&\
    # Docker compose
    curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose &&\
    # Cleanup
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD rootfs /
ENTRYPOINT [ "/start.sh" ]
