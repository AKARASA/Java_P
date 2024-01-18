FROM petechua/docker-vulnerable-dvwa:latest  # Base image with known vulnerabilities

# Install Maven
RUN apt-get update && apt-get install -y maven

# Set the working directory in the container
WORKDIR /app

# Copy only necessary files
COPY pom.xml /app/pom.xml
COPY src /app/src

# Build the WAR file within the container
RUN mvn clean package

# Expose the servlet container's port (if not already exposed in the base image)
EXPOSE 8080  # Adjust the port number based on your application

# Run as a non-root user (if possible in the base image)
USER tomcat  # Adjust if the base image uses a different user

# Deploy the WAR file to the servlet container's webapps directory
# Assuming the WAR file name is my-app.war
COPY target/Web1.war /opt/tomcat/webapps/

# CMD to start the servlet container (assuming the default CMD from the base image is suitable)
CMD ["catalina.sh", "run"]
