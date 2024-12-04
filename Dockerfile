# Build stage
FROM gradle:8.4.0-jdk21-alpine AS build
WORKDIR /app

# Copia solo los archivos necesarios para cachear las dependencias
COPY build.gradle settings.gradle gradle.properties gradlew ./
COPY .gradle .gradle
RUN ./gradlew build --no-daemon || return 0

# Copia el resto de los archivos del proyecto y construye
COPY . .
RUN ./gradlew build --no-daemon

# Run stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Agrega un usuario para evitar ejecutar el contenedor como root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
