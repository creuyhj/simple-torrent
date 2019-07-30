############################
# STEP 1 build executable binary
############################
FROM golang:1.12-alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR /root/cloud-torrent
RUN git clone https://github.com/boypt/cloud-torrent.git .
ENV GO111MODULE=on CGO_ENABLED=0
RUN go build -ldflags "-s -w -X main.VERSION=$(git describe --abbrev=0 --tags)" -o /usr/local/bin/cloud-torrent
############################
# STEP 2 build a small image
############################
FROM alpine
COPY --from=builder /usr/local/bin/cloud-torrent /usr/local/bin/cloud-torrent
ENTRYPOINT ["cloud-torrent"]
