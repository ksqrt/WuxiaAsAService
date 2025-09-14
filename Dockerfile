# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy project files
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Make mvnw executable and download dependencies in a single layer
RUN chmod +x ./mvnw && ./mvnw dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the final, smaller image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/app-service-0.0.1-SNAPSHOT.jar ./app.jar

# Expose the port and run the application
EXPOSE 10000
ENTRYPOINT ["java", "-jar", "app.jar"]
