# Build stage
FROM gradle:8.4.0-jdk21-alpine AS build
WORKDIR /app
COPY build.gradle settings.gradle .gradle/ gradlew .
RUN gradle build --no-daemon

# Run stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]