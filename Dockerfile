# syntax=docker/dockerfile:1-labs
FROM public.ecr.aws/docker/library/alpine:3.20 AS base
ENV TZ=UTC
WORKDIR /src

# source stage =================================================================
FROM base AS source

# get and extract source from git
ARG BRANCH
ARG VERSION
ADD https://github.com/tailscale/tailscale.git#${BRANCH:-v$VERSION} ./

# build stage ==================================================================
FROM base AS build-app
ENV CGO_ENABLED=0

# dependencies
RUN apk add --no-cache git && \
    apk add --no-cache go --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

# build dependencies
COPY --from=source /src/go.mod /src/go.sum ./
RUN go mod download

# build app
COPY --from=source /src ./
ARG VERSION
RUN mkdir /build && \
    go build -trimpath -ldflags "-s -w \
        -X tailscale.com/version.shortStamp=$VERSION \
        -X tailscale.com/version.longStamp=$VERSION-AlpineLinux \
        -X tailscale.com/version.gitCommitStamp=v$VERSION" \
        -o /build/ ./cmd/tailscale ./cmd/tailscaled ./cmd/containerboot

# runtime stage ================================================================
FROM base

ENV S6_VERBOSITY=0 S6_BEHAVIOUR_IF_STAGE2_FAILS=2 PUID=65534 PGID=65534
ENV HOME=/config TS_STATE_DIR=/config TS_USERSPACE=false
WORKDIR /config
VOLUME /config

# copy files
COPY --from=build-app /build /app
COPY ./rootfs/. /

# runtime dependencies
RUN apk add --no-cache tzdata s6-overlay ca-certificates iptables ip6tables iproute2

# run using s6-overlay
ENTRYPOINT ["/init"]
