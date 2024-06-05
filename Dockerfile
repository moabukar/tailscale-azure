FROM golang:1.19.0-alpine3.16 as builder
WORKDIR /app
COPY . ./

# Install any required modules
RUN go mod download
# Copy over Go source code
COPY *.go ./
# Run the Go build and output binary under hello_go_http
RUN go build -o /hello_go_http

FROM alpine:3.16 as tailscale
WORKDIR /app
COPY . ./
ENV TSFILE=tailscale_1.28.0_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1
#COPY . ./
#RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
#RUN apk update && apk add tailscale && rm -rf /var/cache/apk/* && RUN rc-update add tailscale
COPY . ./


FROM alpine:3.16
RUN apk update && apk add ca-certificates bash sudo && rm -rf /var/cache/apk/*

# Azure allows SSH access to the container. This isn't needed for Tailscale to
# operate, but is really useful for debugging the application.
RUN apk add openssh openssh-keygen && rm -rf /var/cache/apk/* && echo "root:Docker!" | chpasswd
RUN apk add netcat-openbsd && rm -rf /var/cache/apk/*
RUN mkdir -p /etc/ssh
COPY sshd_config /etc/ssh/


# Copy binary to production image
COPY --from=builder /app/start.sh /app/start.sh
RUN chmod +x /app/start.sh
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale

RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale


COPY --from=builder /hello_go_http /hello_go_http

EXPOSE 80 2222
# Run on container startup.
CMD ["/app/start.sh"]
