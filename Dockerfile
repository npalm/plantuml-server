FROM openjdk:8-alpine
MAINTAINER Niek Palm <dev.npalm@gmail.com>

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN mkdir /graphviz && \
  apk add --update graphviz

WORKDIR /work

# Download and add maven
RUN MAVEN_VERSION=3.3.3 && \
  wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf -  && \
  mv apache-maven-${MAVEN_VERSION} maven && \
  ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN mkdir /app

# Download and add jetty
RUN JETTY_VERSION=9.4.2.v20170220 && \
  wget http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}/jetty-distribution-${JETTY_VERSION}.tar.gz -O - | tar xzf - && \
  mv /work/jetty-distribution-${JETTY_VERSION} /jetty

# Setup jetty configuration
RUN cd /app && \
  java -jar /jetty/start.jar --create-startd --add-to-start=http,deploy,webapp,jsp

# Build and add plantuml
RUN git clone https://github.com/plantuml/plantuml-server.git && \
  cd plantuml-server && /work/maven/bin/mvn package && mv target/plantuml.war /app/webapps/

# Clean up
RUN apk del git openssl && rm -rf /var/cache/apk/* && rm -rf /work

# Add user to run plantuml server
RUN addgroup plantuml && \
  adduser -H -D -G plantuml plantuml && \
  chown -R plantuml:plantuml /app

USER plantuml

WORKDIR /app
EXPOSE 8080

#ENTRYPOINT ["java", "-jar", "/jetty/start.jar"]
