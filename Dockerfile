FROM ubuntu:bionic
MAINTAINER Rob McBryde <robertmcbryde83@gmail.com>

# Add locales after locale-gen as needed
# Upgrade packages on image
# Preparations for sshd
RUN apt-get -q update

RUN apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables

RUN apt-get install -y locales

RUN locale-gen en_US.UTF-8 &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends openssh-server &&\
    apt-get -q autoremove &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Define additional metadata for our image.
VOLUME /var/lib/docker

# Install Docker Compose
RUN apt-get install -y python-pip
RUN pip install docker-compose

# Install JDK 8 (latest edition)
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk

RUN apt-get install -y git

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    usermod -aG docker jenkins

# Standard SSH port 
EXPOSE 22

# Set Java home evironment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Default command
CMD ["/usr/sbin/sshd", "-D"]


