FROM openjdk:8-jre-alpine

RUN apk add --no-cache \
   # provides envsubst; required for application config file interpolation
   gettext ca-certificates openssl

ARG INSTALL_DIR=/opt/shinyproxy
ARG CONFIG_DIR=/opt/shinyproxy
ARG SHINYPROXY_VERSION=3.0.2

ENV INSTALL_DIR=$INSTALL_DIR
ENV CONFIG_DIR=$CONFIG_DIR
ENV SHINYPROXY_VERSION=$SHINYPROXY_VERSION

WORKDIR $INSTALL_DIR
RUN wget https://www.shinyproxy.io/downloads/shinyproxy-${SHINYPROXY_VERSION}.jar -O shinyproxy.jar

COPY ./certs/prod/localhost.crt /usr/local/share/ca-certificates/prod.crt
COPY ./certs/dev/localhost.crt /usr/local/share/ca-certificates/dev.crt

RUN update-ca-certificates
	
COPY ./docker-entrypoint.sh init-config.sh

RUN chmod +x ./init-config.sh \
  & mkdir -p $CONFIG_DIR

VOLUME $CONFIG_DIR

ENTRYPOINT ["sh", "./init-config.sh"]

COPY favicon.ico /opt/shinyproxy/favicon.ico

CMD ["java", "-jar", "shinyproxy.jar"]
