FROM appdynamics/mixapp-base:java

MAINTAINER Jennifer Li (jennifer.li@appdynamics.com)

# Environment vars: Tomcat
ENV CATALINA_HOME /tomcat

# Environment settings for startup scripts
ADD env.sh /
RUN chmod +x /env.sh

# Install Tomcat
COPY /apache-tomcat.tar.gz /apache-tomcat.tar.gz
RUN tar zxf apache-tomcat.tar.gz \
    && rm apache-tomcat.tar.gz \
    && mv apache-tomcat* tomcat
RUN cd ${CATALINA_HOME}/bin;chmod +x *.sh

# App Server Agent Install
ADD JavaAgent.zip /
RUN unzip -q /JavaAgent.zip -d ${CATALINA_HOME}/appagent;rm JavaAgent.zip

# Machine Agent
ADD MachineAgent.zip /
RUN unzip -q /MachineAgent.zip -d /machine-agent;rm MachineAgent.zip

ADD runMachineAgent.sh /
RUN chmod +x /runMachineAgent.sh

# Analytics within Machine Agent
ADD configAnalytics.sh /
RUN chmod +x /configAnalytics.sh

# ADD TechStack.war ${CATALINA_HOME}/webapps/
ADD SimpleJava/ /SimpleJava
RUN cd /SimpleJava && mvn install && mvn package -Dmaven.test.skip=true
RUN cp /SimpleJava/target/SimpleJava.war ${CATALINA_HOME}/webapps/

# Startup scripts
ADD startup.sh /
RUN chmod +x /startup.sh

# Get logs script
ADD get_logs.sh /
RUN chmod +x /get_logs.sh

WORKDIR /

# Note: This command should not return or the container will exit
CMD "/startup.sh"

EXPOSE 80
EXPOSE 8080
EXPOSE 8009