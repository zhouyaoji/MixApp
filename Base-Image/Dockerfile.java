FROM ubuntu:14.04
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update
RUN apt-get -y install curl
RUN apt-get -y install unzip

# Install java
# Accept the license
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections

RUN apt-get -y install oracle-java7-installer

