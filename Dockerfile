# Build stage (using a vulnerable Maven version)
FROM debricked/vulnerable-functionality-maven:v0.5.0 AS builder
WORKDIR /app

# Create the tomcat user
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat

# Copy only necessary files for a more efficient build
COPY pom.xml .
COPY src .

# Build the application with Maven
RUN mvn clean package

# Final stage (using a vulnerable Tomcat image)
FROM tomcat:latest

# Create the tomcat user in the final stage as well
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat

# Copy the WAR file from the builder stage to the Tomcat image
COPY --from=builder /app/target/Web1.war /usr/local/tomcat/webapps/

# Copy the server.xml from the builder stage to the Tomcat image
COPY --from=builder /usr/local/tomcat/conf/server.xml /usr/local/tomcat/conf/server.xml

# Grant read permissions to the tomcat user for server.xml
RUN chmod +r /usr/local/tomcat/conf/server.xml

# Adjust ownership for Tomcat directories
RUN chown -R tomcat:tomcat /usr/local/tomcat

# Run as the tomcat user
USER tomcat

# Expose the servlet container's port
EXPOSE 8080

# Note: This Dockerfile uses images with known vulnerabilities for educational/testing purposes.
# It is NOT recommended for production or sensitive environments.
