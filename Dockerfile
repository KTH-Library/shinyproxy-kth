#FROM eclipse-temurin:17.0.10_7-jre-alpine

##RUN apt-get update -y && apt-get install -y \
   # provides envsubst; required for application config file interpolation

FROM eclipse-temurin:22_36-jre-alpine

RUN apk add --no-cache \
   gettext ca-certificates openssl bash

ARG INSTALL_DIR=/opt/shinyproxy
ARG CONFIG_DIR=/opt/shinyproxy
ARG SHINYPROXY_VERSION=3.1.1

ENV INSTALL_DIR=$INSTALL_DIR
ENV CONFIG_DIR=$CONFIG_DIR
ENV SHINYPROXY_VERSION=$SHINYPROXY_VERSION

WORKDIR $INSTALL_DIR
RUN wget -c -T 5 "https://www.shinyproxy.io/downloads/shinyproxy-${SHINYPROXY_VERSION}.jar" -O shinyproxy.jar


#COPY ./certs/prod/localhost.crt /usr/local/share/ca-certificates/prod.crt
#COPY ./certs/dev/localhost.crt /usr/local/share/ca-certificates/dev.crt

COPY ./certs/prod/localhost.crt /certificates/prod.crt
COPY ./certs/dev/localhost.crt /certificates/dev.crt
RUN USE_SYSTEM_CA_CERTS=true /__cacert_entrypoint.sh

RUN update-ca-certificates
#RUN CACERT="$JAVA_HOME/lib/security/cacerts" trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose=server-auth "$CACERT"

#COPY ./docker-entrypoint.sh init-config.sh

#RUN chmod +x ./init-config.sh \
#  & mkdir -p $CONFIG_DIR

VOLUME $CONFIG_DIR

#ENTRYPOINT ["sh", "./init-config.sh"]

COPY favicon.ico /opt/shinyproxy/favicon.ico

CMD ["java",  "-jar", "shinyproxy.jar", "--spring.jmx.enabled=false", "--spring.config.location=/opt/shinyproxy/application.yml"]
