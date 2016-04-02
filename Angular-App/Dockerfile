FROM appdynamics/mixapp-base:node

MAINTAINER Jennifer Li (jennifer.li@appdynamics.com)

# Add app source
RUN mkdir /mixapp-angular
ADD /mixapp-angular /mixapp-angular

# Install app dependencies
RUN cd /mixapp-angular/server && npm install

# Add start script
COPY /start.sh /
RUN chmod 777 /start.sh

COPY /update-rum-key.sh /
RUN chmod 777 /update-rum-key.sh

# Expose Ports
EXPOSE  8000

CMD /start.sh 
