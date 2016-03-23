FROM appdynamics/mixapp-base:cpp

MAINTAINER Jennifer Li (jennifer.li@appdynamics.com)

# Add native SDK
ENV SDK_HOME /opt
ENV NATIVE_HOME ${SDK_HOME}/appdynamics-sdk-native
ADD 02-appd.conf ${SDK_HOME}/

# Set up C++ native SDK
ADD appdynamics-sdk-native.tar.gz ${SDK_HOME}
ADD appdynamics_sdk.conf /etc/ld.so.conf.d/
RUN ldconfig
RUN (cd ${SDK_HOME} gunzip ${SDK_HOME}/appdynamics-sdk-native.tar.gz.tar.gz)
RUN (cd ${SDK_HOME} tar xf ${SDK_HOME}/appdynamics-sdk-native.tar.gz.tar)
RUN chmod 777 ${NATIVE_HOME}/logs
RUN chmod 744 ${NATIVE_HOME}/install.sh
RUN ${NATIVE_HOME}/install.sh

# Machine Agent
ADD MachineAgent.zip /
RUN unzip -q /MachineAgent.zip -d /machine-agent;rm MachineAgent.zip

ADD runMachineAgent.sh /
RUN chmod +x /runMachineAgent.sh

# Analytics within Machine Agent
ADD configAnalytics.sh /
RUN chmod +x /configAnalytics.sh

# Add C++ app and build script
ADD ./app/ $NATIVE_HOME/app
ADD build.sh $NATIVE_HOME/
ADD env.sh $NATIVE_HOME/
RUN chmod 744 ${NATIVE_HOME}/build.sh
RUN chmod 744 ${NATIVE_HOME}/env.sh
RUN chmod 7777 -R ${NATIVE_HOME}
ADD startup.sh /
RUN chmod 744 /startup.sh

# Run startup script and tail Apache error log
CMD /startup.sh

EXPOSE 80
