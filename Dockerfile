# From OpenJDK base image
FROM openjdk:8-jre-slim

# Create ActiveMQ user
RUN useradd -m activemq

# Install Active MQ
ENV ACTIVEMQ_ROOT /opt/activemq
WORKDIR ${ACTIVEMQ_ROOT}
ADD http://apache.mirrors.spacedump.net/activemq/5.15.3/apache-activemq-5.15.3-bin.tar.gz ${ACTIVEMQ_ROOT}
RUN tar -zxvf apache-activemq-5.15.3-bin.tar.gz && \
   rm apache-activemq-5.15.3-bin.tar.gz

# Setup broker instance
ENV ACTIVEMQ_HOME ${ACTIVEMQ_ROOT}/apache-activemq-5.15.3
WORKDIR ${ACTIVEMQ_HOME}
ADD activemq.xml conf/
ADD log4j.properties conf/
RUN chown -R activemq:activemq ${ACTIVEMQ_ROOT}

# Set system variables user in configuration
RUN sed -i 's/^ *ACTIVEMQ_OPTS_MEMORY=.*$/ACTIVEMQ_OPTS_MEMORY="-Xms7G -Xmx7G"/' bin/env

# Mount data directory
VOLUME ${ACTIVEMQ_HOME}/data

# Expose standard ports
EXPOSE 5672 8161

# Execute
USER activemq
CMD bin/activemq console
