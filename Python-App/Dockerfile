FROM appdynamics/mixapp-base:python

MAINTAINER Jennifer Li (jennifer.li@appdynamics.com)

# Install app
ADD . /appd/Python-App

# Build startup script 
ADD /build_startup_script.sh /appd/
RUN chmod 777 /appd/build_startup_script.sh

# Add startup script
ADD /startup.sh /appd/
RUN chmod 777 /appd/startup.sh
ADD /env.sh /appd/
RUN chmod 777 /appd/env.sh
ADD /start.sh /appd/Python-App/
RUN chmod 777 /appd/Python-App/start.sh

# Install -pre python agent
RUN ./appd/build_startup_script.sh

# Machine Agent
ADD MachineAgent.zip /
RUN unzip -q /MachineAgent.zip -d /machine-agent;rm MachineAgent.zip

ADD runMachineAgent.sh /
RUN chmod +x /runMachineAgent.sh

# Analytics within Machine Agent
ADD configAnalytics.sh /
RUN chmod +x /configAnalytics.sh

# Expose Ports
EXPOSE 9000

CMD /appd/startup.sh && tail -F /var/log/dmesg
