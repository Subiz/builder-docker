FROM subiz/configmap:1 as configmap
FROM subiz/up:0.3.6 as up
FROM golang:1.11.0-alpine3.8 as go
FROM node:8.11.4-alpine

RUN apk update && apk add git curl wget bind-tools

COPY --from=go /usr/local/go /usr/local/go
RUN export PATH="/usr/local/go/bin:$PATH"; go version
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

COPY --from=up /usr/local/bin/up /usr/local/bin/up
RUN up --version

COPY --from=configmap /usr/local/bin/configmap /usr/local/bin/configmap
ENV VAULT_ADDR=https://vault.subiz.com
RUN configmap --version
