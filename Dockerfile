# Build stage
FROM gradle:8.4.0-jdk21 AS build
WORKDIR /app
COPY . /app
RUN gradle build --no-daemon

# Run stage
FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]