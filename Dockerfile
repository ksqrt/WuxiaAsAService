# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper and pom.xml
# Using --chmod to ensure mvnw is executable
COPY --chmod=755 mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies. This creates a separate layer for dependencies.
RUN ./mvnw dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Package the application
RUN ./mvnw package -DskipTests

# Stage 2: Create the final, lightweight image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]