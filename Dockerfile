FROM --platform=linux/amd64 keppel.eu-de-1.cloud.sap/ccloud-dockerhub-mirror/library/golang:1.22 as builder
LABEL source_repository="https://github.com/Kuckkuck/k8s-event-logger"
WORKDIR /go/src/github.com/Kuckkuck/k8s-event-logger
COPY . .
RUN go mod vendor
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o k8s-event-logger &&\
    if ldd 'k8s-event-logger'; then exit 1; fi; # Ensure binary is statically-linked

FROM --platform=linux/amd64 scratch
WORKDIR /go/src/github.com/Kuckkuck/k8s-event-logger
LABEL source_repository="https://github.com/Kuckkuck/k8s-event-logger"
COPY --from=builder /go/src/github.com/Kuckkuck/k8s-event-logger/k8s-event-logger /
USER 10001
ENTRYPOINT ["/k8s-event-logger"]
