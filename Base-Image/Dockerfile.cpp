FROM appdynamics/ecommerce-java:oracle-java7

MAINTAINER Jennifer Li (jennifer.li@appdynamics.com)

# set timezone to UTC
RUN mv /etc/localtime /etc/localtime.bak
RUN ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN yum install -y epel-release
RUN yum install -y npm
RUN npm install -g node-gyp-install
RUN yum install -y curl-devel

