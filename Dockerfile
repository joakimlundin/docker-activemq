# From Ubuntu base image
FROM ubuntu:14.04

# Install java
RUN \
   echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
   apt-get update && \
   apt-get install -y software-properties-common && \
   add-apt-repository -y ppa:webupd8team/java && \
   apt-get update && \
   apt-get install -y oracle-java8-installer && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/* && \
   rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

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
 
# Mount data directory
VOLUME ${ACTIVEMQ_HOME}/data

# Expose standard ports
EXPOSE 5672 8161

# Execute
USER activemq
CMD bin/activemq console
