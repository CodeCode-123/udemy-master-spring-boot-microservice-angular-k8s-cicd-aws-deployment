FROM jenkins/jenkins:lts-jdk25

# Switch to root user to install packages with apt
USER root

# Update apt and install libatomic1 and curl/apt-transport prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libatomic1 \
    curl \
    ca-certificates \
    gnupg \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key and repository
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://docker.com | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://docker.com $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install only the CLI (not the full daemon)
RUN apt-get update && apt-get install -y docker-ce-cli

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

