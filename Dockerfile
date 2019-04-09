FROM ubuntu:bionic
MAINTAINER Rob McBryde <robertmcbryde83@gmail.com>

# Install JDK 8 (latest edition)
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk

RUN apt-get install -y git

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins && \
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port 
EXPOSE 22

# Set Java home evironment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Default command
CMD ["/bin/bash", "-D"]


