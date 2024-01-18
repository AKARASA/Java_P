# Build stage (using a vulnerable Maven version)
FROM appsecco/vulnerable-maven:3.6.3-jdk-8 AS builder  # Known vulnerabilities
WORKDIR /app
COPY pom.xml .
COPY src .
RUN mvn clean package

# Final stage (using a vulnerable Tomcat image)
FROM vulnerables/tomcat7-cve-2020-1938:8.5.54  # Vulnerable Tomcat with known exploit
COPY --from=builder /app/target/my-app.war /usr/local/tomcat/webapps/

# Run as a non-root user (adjust if the base image uses a different user)
USER tomcat

# Expose the servlet container's port
EXPOSE 8080
