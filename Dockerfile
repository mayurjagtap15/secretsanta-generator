FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/secretsanta-0.0.1-SNAPSHOT.jar $APP_HOME/app.jar

ENV APP_PORT=8080

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
