FROM golang:1.13-stretch as build-env

ADD . /opt/src

WORKDIR /opt/src

RUN go build -o /opt/src/server .

FROM gcr.io/distroless/base
COPY --from=build-env /opt/src/server  /
ENTRYPOINT ["/server"]
