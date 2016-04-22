FROM centos:centos7

MAINTAINER mark.prichard@appdynamics.com

RUN yum install -y boost-devel
RUN yum install -y gcc-c++
RUN yum install -y wget

# Add native SDK
ENV SDK_HOME /opt
ENV NATIVE_HOME ${SDK_HOME}/appdynamics-sdk-native

# Set up C++ native SDK
ADD appdynamics-sdk-native.tar.gz ${SDK_HOME}
ADD appdynamics_sdk.conf /etc/ld.so.conf.d/
RUN ldconfig
RUN (cd ${SDK_HOME} gunzip ${SDK_HOME}/appdynamics-sdk-native.tar.gz.tar.gz)
RUN (cd ${SDK_HOME} tar xf ${SDK_HOME}/appdynamics-sdk-native.tar.gz.tar)
RUN chmod 777 ${NATIVE_HOME}/logs
RUN chmod 744 ${NATIVE_HOME}/install.sh
RUN ${NATIVE_HOME}/install.sh
RUN cp $NATIVE_HOME/sdk_lib/lib/libappdynamics_native_sdk.so /usr/lib64/

#RUN wget -O boost.1.53.tar.gz https://sourceforge.net/projects/boost/files/boost/1.53.0/boost_1_53_0.tar.gz/download
#RUN tar -xvf boost.1.53.tar.gz boost_1_53_0/doc/html/boost_asio/example/http/
#ENV BOOST_DEV /boost_1_53_0/doc/html/boost_asio/example/http/
#RUN rm boost.1.53.tar.gz

ADD http/ /boost/
ENV BOOST_DEV /boost/

WORKDIR ${BOOST_DEV}
ADD startup.sh $BOOST_DEV/
RUN chmod +x startup.sh
ADD index.html $BOOST_DEV/server/
CMD bash

EXPOSE 8090