# syntax = docker/dockerfile:1.3
FROM golang:1.23 AS build

WORKDIR /go/src/github.com/mccutchen/go-httpbin

COPY . .

RUN --mount=type=cache,id=gobuild,target=/root/.cache/go-build \
    make build buildtests

FROM bash:latest

# Create a new user called "1000"
RUN adduser --disabled-password --gecos '' 1000

# Copy the binary from the build stage to the new image
COPY --from=build /go/src/github.com/mccutchen/go-httpbin/dist/go-httpbin* /bin/

RUN chown 1000:1000 /bin/go-httpbin

USER 1000

EXPOSE 8080
CMD ["/bin/go-httpbin"]
