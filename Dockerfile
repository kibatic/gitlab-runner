FROM debian:10

ENV DOCKER_COMPOSE_VERSION 1.29.2

RUN apt-get -qq update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install\
    build-essential \
    ca-certificates \
    openvpn \
    python3-pip \
    python3-setuptools \
    openssh-client \
    curl \
    git \
    rsync \
    netcat \
    psmisc \
    dnsutils &&\
    # Docker install
    curl -sSL https://get.docker.com | sh &&\
    # Docker compose
    curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose &&\
    # AWS CLI
    python3 -m pip install awscli==1.17.6 &&\
    # Cleanup
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD rootfs /

CMD "/bin/bash"
ENTRYPOINT [ "/start.sh" ]
