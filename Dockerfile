FROM golang:1.16-alpine  AS build-env

# Dependencies
WORKDIR /build
ENV GO111MODULE=on
COPY go.mod go.sum ./
RUN go mod download

# Build
COPY cmd cmd/
COPY pkg pkg/

RUN CGO_ENABLED=0 go build -ldflags '-w -s' -o /app/voice-cert-checker ./cmd/

# Build runtime container
FROM scratch
LABEL description="Certificate monitoring utility for watching voice tls certificates and reporting the result as metrics."
WORKDIR /app
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build-env --chown=35212:35212 /app/voice-cert-checker /app/voice-cert-checker

USER 35212:35212

CMD ["/app/voice-cert-checker"]
