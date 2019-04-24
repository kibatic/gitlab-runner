FROM debian:9

ENV DOCKER_COMPOSE_VERSION 1.23.2

RUN apt-get -qq update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install\
    build-essential \
    ca-certificates \
    openvpn \
    openssh-client \
    curl \
    git \
    netcat \
    dnsutils &&\
    # Docker install
    curl -sSL https://get.docker.com | sh &&\
    # Docker compose
    curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose &&\
    # Cleanup
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD rootfs /

CMD "/bin/bash"
ENTRYPOINT [ "/start.sh" ]
