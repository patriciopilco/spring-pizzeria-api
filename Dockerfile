# Build stage
FROM gradle:7.4-jdk17 as build
ENV SPRING_PROFILES_ACTIVE=production
WORKDIR /app
COPY . /app
# Start with a base image containing Java runtime
FROM openjdk:11-jdk-slim

# The application's .jar file
ARG JAR_FILE=target/*.jar

# Add the application's .jar to the container
COPY ${JAR_FILE} app.jar

# Define build-time variables
ARG DB_HOST
ARG DB_PORT
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD

# Set environment variables
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_NAME=${DB_NAME}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}

# Run the application
ENTRYPOINT ["java","-jar","/app.jar"]
RUN gradle build --no-daemon

# Run stage
FROM eclipse-temurin:17-jdk
ENV SPRING_PROFILES_ACTIVE=production
USER 10001
VOLUME /tmp
COPY --from=build /app/build/libs/*.jar app.jar
# Define build-time variables
ARG DB_HOST
ARG DB_PORT
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD

# Set environment variables
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_NAME=${DB_NAME}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}
ENTRYPOINT ["java","-jar","/app.jar"]