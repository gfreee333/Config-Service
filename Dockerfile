FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
RUN apk add --no-cache curl
COPY --from=builder /build/target/config-service-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=dev", "/app/app.jar"]