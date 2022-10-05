FROM debian:bullseye-slim

ENV DOCKER_COMPOSE_VERSION 2.11.2

RUN apt-get -qq update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    build-essential \
    ca-certificates \
    openvpn \
    python3-pip \
    python3-setuptools \
    openssh-client \
    curl \
    gnupg \
    lsb-release \
    git \
    rsync \
    netcat \
    psmisc \
    dnsutils &&\
    # Docker install \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
    # Docker compose \
    curl -SL https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose &&\
    # AWS CLI
    python3 -m pip install awscli==1.17.6 &&\
    # Cleanup
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD rootfs /

CMD "/bin/bash"
ENTRYPOINT [ "/start.sh" ]
