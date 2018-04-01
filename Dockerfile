FROM tomcat:jre8-alpine
COPY target/AngularJavaApp.war /usr/local/tomcat/webapps/AngularJavaApp.war

CMD ["catalina.sh", "run"]
