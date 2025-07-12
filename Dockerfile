FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/secretsanta-generator.jar app.jar

ENV APP_PORT=8080

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
