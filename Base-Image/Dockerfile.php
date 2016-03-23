FROM centos:centos6

MAINTAINER Jennifer Li (jennifer.li@appdynamics.com)

# Install resources
# Centos 6 installs Apache 2.2 by default: we want 2.4
RUN yum clean all
RUN yum -y install wget && yum clean all
RUN cd /etc/yum.repos.d/; wget http://repos.fedorapeople.org/repos/jkaluza/httpd24/epel-httpd24.repo
RUN yum -y install httpd24.x86_64
RUN yum -y install php
RUN yum -y install php-cli
RUN yum -y install unzip
RUN yum -y install bzip2
RUN yum -y install tar
RUN yum -y install which
RUN yum -y install curl
RUN yum -y install java-1.7.0-openjdk-devel

