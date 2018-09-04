FROM subiz/configmap:1 as configmap
FROM golang:1.11.0-alpine3.8 as go
#FROM node:8.11.4-alpine
# FROM gcr.io/cloud-builders/kubectl

FROM alpine

COPY --from=go /usr/local/go /usr/local/go

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN export PATH="/usr/local/go/bin:$PATH"

RUN apk update && apk add docker git curl jq

COPY --from=configmap /usr/local/bin/configmap /usr/local/bin/configmap
ENV VAULT_ADDR=https://vault.subiz.com
RUN configmap --version
