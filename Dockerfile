FROM subiz/configmap:1 as configmap
FROM subiz/up:0.3.6 as up
FROM golang:1.11.0-alpine3.8 as go
#FROM node:8.11.4-alpine
# FROM gcr.io/cloud-builders/kubectl

FROM launcher.gcr.io/google/ubuntu16_04

RUN apt-get -y update && \
    apt-get -y install \
		    jq \
        git \
        apt-transport-https \
        ca-certificates \
        curl \
        make \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       xenial \
       edge" && \
    apt-get -y update && \
    apt-get -y install docker-ce=17.12.0~ce-0~ubuntu

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
