FROM subiz/configmap:1 as configmap
FROM golang:1.11.0-alpine3.8 as go
FROM alpine:3.8

RUN apk update && apk add docker

# GOLANG
COPY --from=go /usr/local/go /usr/local/go
RUN export PATH="/usr/local/go/bin:$PATH"; go version
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

COPY --from=configmap /usr/local/bin/configmap /usr/local/bin/configmap
