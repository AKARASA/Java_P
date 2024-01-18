FROM petechua/docker-vulnerable-dvwa :latest  # Base image with known vulnerabilities

# Copy only necessary files
COPY pom.xml /app/pom.xml
COPY src /app/src

# Build the WAR file within the container
RUN mvn -f /app/pom.xml clean package

# Expose the servlet container's port
EXPOSE 80

# Run as a non-root user (if possible in the base image)
USER tomcat  # Adjust if the base image uses a different user

# Deploy the WAR file to the servlet container's webapps directory
COPY --from=builder /app/target/my-app.war /var/www/html/

# No need for CMD, as the servlet container will start automatically
