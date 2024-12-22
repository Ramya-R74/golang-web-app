# Stage 1: Build the Go application
FROM golang:1.22.5 as base

# metadata
MAINTAINER Ramya R <ramyawork22@gmail.com>
LABEL app=golang-web-app

WORKDIR /app

# Copy go.mod and go.sum (if present) to enable caching of dependencies
COPY go.mod .

RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o main .

# Stage 2: Use a minimal base image for the final executable
FROM gcr.io/distroless/base

# Copy the built application and necessary static files
COPY --from=base /app/main /
COPY --from=base /app/static /static

# Expose the application port
EXPOSE 8080

# Define the command to run the application
CMD ["/main"]

