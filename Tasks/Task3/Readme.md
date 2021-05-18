# Create a Docker file that exposes the basic web app.

- #It will pull tomcat:8.0-alpine image & initializes a new build stage and sets the Base Image for subsequent instructions.
- FROM tomcat:8.0-alpine

- #sets the Author field of the generated images.
- LABEL maintainer="kislay4@gmail.com"

- #Copy files from the local storage to a destination in the Docker image.
- ADD target/SampleWebApp-0.0.1.war /usr/local/tomcat/webapps/

- #Instructing container to listens on the specified network ports at runtime.
- EXPOSE 8080

- #It is executed to start the Tomcat server.
- CMD ["catalina.sh", "run"]

### Below screenshot from jenkins console output for docker file execution.

 ![image](https://user-images.githubusercontent.com/24701958/118628817-98e05100-b7ea-11eb-9dbf-2ec23838570a.png)




