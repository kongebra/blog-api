FROM golang:1.13 as base

EXPOSE 80
EXPOSE 443

WORKDIR /app

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -ldflags '-s -w' -o main main.go

### Certs
FROM alpine:latest as certs

RUN apk --update add ca-certificates

### App
FROM scratch as app

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=base app /

ENTRYPOINT ["/main"]