FROM appdynamics/mixapp-base:php

MAINTAINER Jennifer Li (jennifer.li@appdynamics.com)

# Use Apache Worker MPM
ENV HTTPD_24 /opt/rh/httpd24/root/etc/httpd
ADD 00-mpm.conf ${HTTPD_24}/conf.modules.d/00-mpm.conf

# Add files in place
ADD *.php /var/www/html/

RUN apachectl start

# Environment settings for startup scripts
ADD env.sh /
RUN chmod +x /env.sh

# Install bits and setup install for AppD Agent
ADD PHPAgent.tar.bz2 /var/www/
RUN chmod 777 /var/www/appdynamics-php-agent/logs
RUN chmod -R 755 /var/www/appdynamics-php-agent/php

# Change config settings to enable debugging
ADD appdynamics_agent_log4cxx.xml.template /var/www/appdynamics-php-agent/php/conf

# Machine Agent
COPY MachineAgent.zip /
RUN unzip -q /MachineAgent.zip -d /machine-agent;rm MachineAgent.zip

ADD runMachineAgent.sh /
RUN chmod +x /runMachineAgent.sh

# Analytics within Machine Agent
ADD configAnalytics.sh /
RUN chmod +x /configAnalytics.sh

# Add Env script
ADD /env.sh /appdynamics/
RUN chmod 777 /appdynamics/env.sh

# Add startup script
ADD startup.sh /
RUN chmod 777 /startup.sh

# Expose Ports
EXPOSE 80

# Start the app
CMD /startup.sh
