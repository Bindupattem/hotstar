
FROM alpine:3.19 AS artifact

WORKDIR /app


COPY target/*.war app.war



FROM tomcat:9


RUN rm -rf /usr/local/tomcat/webapps/*


COPY --from=artifact /app/app.war /usr/local/tomcat/webapps/Root.WAR


EXPOSE 80


CMD ["catalina.sh", "run"]
