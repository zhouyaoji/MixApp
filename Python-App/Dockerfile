FROM appdynamics/python-base

################## BEGIN INSTALLATION ######################

# Install Java
RUN apt-get update
RUN apt-get -y install default-jdk

# Install app
ADD . /appd/Python-App
RUN chown -R appdynamics.appdynamics /appd

# Add startup script
ADD /startup.sh /appd/
RUN chmod 777 /appd/startup.sh
ADD /env.sh /appd/
RUN chmod 777 /appd/env.sh
ADD /start.sh /appd/Python-App/
RUN chmod 777 /appd/Python-App/start.sh
RUN chown -R appdynamics.appdynamics /appd

# Machine Agent
ADD MachineAgent.zip /
RUN unzip -q /MachineAgent.zip -d /machine-agent;rm MachineAgent.zip

ADD runMachineAgent.sh /
RUN chmod +x /runMachineAgent.sh

# Analytics within Machine Agent
ADD configAnalytics.sh /
RUN chmod +x /configAnalytics.sh

##################### INSTALLATION END #####################

# Expose Ports
EXPOSE 9000

CMD /appd/startup.sh && tail -F /var/log/dmesg
