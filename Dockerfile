FROM eclipse-temurin:25-jre-resolute

RUN apt-get update -y && apt-get install -y --no-install-recommends \
   gettext-base ca-certificates openssl bash wget \
   && rm -rf /var/lib/apt/lists/*

ARG INSTALL_DIR=/opt/shinyproxy
ARG CONFIG_DIR=/opt/shinyproxy
ARG SHINYPROXY_VERSION=3.2.4

ENV INSTALL_DIR=$INSTALL_DIR
ENV CONFIG_DIR=$CONFIG_DIR
ENV SHINYPROXY_VERSION=$SHINYPROXY_VERSION

WORKDIR $INSTALL_DIR
RUN wget -c -T 5 "https://www.shinyproxy.io/downloads/shinyproxy-${SHINYPROXY_VERSION}.jar" -O shinyproxy.jar

VOLUME $CONFIG_DIR

COPY favicon.ico /opt/shinyproxy/favicon.ico

CMD ["java",  "-jar", "shinyproxy.jar", "--spring.jmx.enabled=false", "--spring.config.location=/opt/shinyproxy/application.yml"]
