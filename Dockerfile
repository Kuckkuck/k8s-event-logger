FROM --platform=${BUILDPLATFORM} golang:1.22.0 as builder
#FROM --platform=${BUILDPLATFORM} golang:1.20.5 as builder
LABEL source_repository="https://github.com/Kuckkuck/k8s-event-logger"
ARG TARGETARCH amd64
ARG TARGETOS linux
ARG TARGETPLATFORM linux/amd64
WORKDIR /go/src/github.com/Kuckkuck/k8s-event-logger
COPY . .
RUN go mod vendor
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o k8s-event-logger &&\
    if ldd 'k8s-event-logger'; then exit 1; fi; # Ensure binary is statically-linked

FROM --platform=${TARGETPLATFORM} scratch
COPY --from=builder /go/src/github.com/Kuckkuck/k8s-event-logger/k8s-event-logger /
USER 10001
ENTRYPOINT ["/k8s-event-logger"]
