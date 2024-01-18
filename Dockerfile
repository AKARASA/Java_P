FROM petechua/docker-vulnerable-dvwa:1.0

# Install Maven
RUN apt-get update && apt-get install -y maven

# Set the working directory in the container
WORKDIR /app

# Copy only necessary files and build the WAR file within the container
COPY pom.xml /app/pom.xml
COPY src /app/src
RUN mvn clean package

# Expose the servlet container's port (if not already exposed in the base image)
EXPOSE 9001  

# Run as a non-root user (if possible in the base image)
USER tomcat

# Deploy the WAR file to the servlet container's webapps directory
# Assuming the WAR file name is my-app.war
COPY target/my-app.war /usr/local/tomcat/webapps/

# CMD to start the servlet container (assuming the default CMD from the base image is suitable)
CMD ["catalina.sh", "run"]
