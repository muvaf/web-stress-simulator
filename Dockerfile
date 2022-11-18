FROM maven:3.8.6-jdk-8

#Fetch Maven plugins
COPY src/web-app /opt/src/web-app
RUN cd /opt/src/web-app && mvn clean install && rm -rf /opt/src

## Intermediate image

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.83
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
        && echo "Installing Tomcat" \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

EXPOSE 8080
CMD ["catalina.sh", "run"]

## Original image starts below

COPY src/web-app /opt/src/web-app

RUN cd /opt/src/web-app && mvn clean install && mv target/*.war /usr/local/tomcat/webapps/


