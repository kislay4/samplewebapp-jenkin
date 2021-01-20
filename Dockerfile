FROM tomcat:8.0-alpine
LABEL maintainer="kislay4@gmail.com"
ADD targets/SampleWebApp-0.0.1.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
