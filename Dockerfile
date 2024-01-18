# Use an official Maven runtime as a parent image
FROM tomcat:9-jdk11  # Or another suitable image like jetty

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the pom.xml file into the container at /usr/src/app
COPY pom.xml .

# Download the Maven dependencies (this step is separate to leverage Docker layer caching)
RUN mvn dependency:go-offline

# Copy the rest of the application code into the container
COPY src ./src

# Build the WAR file
RUN mvn package

