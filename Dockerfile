FROM jenkins/jenkins:lts-jdk25

# Switch to root user to install packages with apt
USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends libatomic1 && \
    rm -rf /var/lib/apt/lists/*

# Switch back to the default jenkins user
USER jenkins