# Use an official Maven runtime as a parent image
FROM maven:3.8.4-openjdk-11-slim AS build

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the project files into the container
COPY . .

# Build the application
RUN mvn clean install

# Use an official Tomcat runtime as a parent image
FROM tomcat:9-jdk11-openjdk-slim

# Copy the war file from the Maven build stage to the Tomcat webapps directory
COPY --from=build /usr/src/app/target/your-servlet-app.war /usr/local/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
