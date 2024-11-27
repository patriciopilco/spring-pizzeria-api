# Build stage
FROM gradle:8.4.0-jdk21 AS build
# Define build-time variables
#ARG DB_HOST
#ARG DB_PORT
#ARG DB_NAME
#ARG DB_USER
#ARG DB_PASSWORD

# Set environment variables
ENV JWT_SECRET=${JWT_SECRET}
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_NAME=${DB_NAME}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}

WORKDIR /app
COPY . .
RUN gradle build --no-daemon

# Run stage
FROM eclipse-temurin:21-jdk-jammy
USER 10001
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]