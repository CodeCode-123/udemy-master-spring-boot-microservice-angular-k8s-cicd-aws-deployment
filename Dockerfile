FROM jenkins/jenkins:lts-jdk25

# Switch to root user to install packages with apt
USER root

# 1. Update packages and install libatomic1
RUN apt-get update && \
    apt-get install -y --no-install-recommends libatomic1 curl && \
    rm -rf /var/lib/apt/lists/*

# 2. Download and install static Docker CLI binary for arm64 (Apple Silicon)
# Adjust the version string below if you need a specific Docker version
ARG DOCKER_VERSION="27.3.1"
RUN curl -fsSL "https://docker.com{DOCKER_VERSION}.tgz" -o /tmp/docker.tgz && \
    tar -xzf /tmp/docker.tgz -C /tmp && \
    mv /tmp/docker/docker /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker && \
    rm -rf /tmp/docker /tmp/docker.tgz

# 3. Create a docker group matching typical GIDs and add the jenkins user to it
# Note: On macOS, Docker Desktop uses root-like permissions on the socket,
# but setting up the group structure ensures pipeline execution scripts remain portable.
RUN groupadd -g 999 docker || true && \
    usermod -aG docker jenkins

## Install prerequisites, Docker CLI repository, and libatomic1
#RUN apt-get update && apt-get install -y --no-install-recommends libatomic1 \
#    && rm -rf /var/lib/apt/lists/*

# Switch back to the default jenkins user
USER jenkins


#RUN apt-get update && \
#        apt-get install -y --no-install-recommends libatomic1 \
#        ca-certificates \
#        curl \
#        gnupg \
#        lsb-release \
#        && mkdir -p /etc/apt/keyrings \
#        && curl -fsSL https://docker.com | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
#        && echo \
#          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://docker.com \
#          $(lsb_release -cs) stable" | tee /etc/apt/to-list/docker.list > /dev/null \
#        && apt-get update && apt-get install -y docker-ce-cli \
#        && rm -rf /var/lib/apt/lists/*
#
## Add jenkins user to the root group to ensure it can access the mounted socket
#RUN usermod -aG root jenkins

