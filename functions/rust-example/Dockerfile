# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM rust:alpine AS chef
ARG TARGETPLATFORM

RUN <<EOT
    if [ "$TARGETPLATFORM" != "linux/arm64" ] && [ "$TARGETPLATFORM" != "linux/amd64" ]; then
      >&2 echo "Error: TARGETPLATFORM must be either 'linux/arm64' or 'linux/amd64'."
      exit 1
    fi
EOT

WORKDIR /app
ENV PKG_CONFIG_SYSROOT_DIR=/
RUN apk add --no-cache musl-dev openssl-dev zig
RUN cargo install --locked cargo-zigbuild cargo-chef
RUN rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json

RUN \
    cargo chef cook \
        --release \
        --zigbuild \
        --recipe-path recipe.json \
        --target x86_64-unknown-linux-musl \
        --target aarch64-unknown-linux-musl

COPY . .
RUN cargo zigbuild -r \
    --target x86_64-unknown-linux-musl --target aarch64-unknown-linux-musl && \
    mkdir /app/linux && \
    cp target/aarch64-unknown-linux-musl/release/prog /app/linux/arm64 && \
    cp target/x86_64-unknown-linux-musl/release/prog /app/linux/amd64

FROM public.ecr.aws/lambda/provided:al2023 AS runtime
ARG TARGETPLATFORM
COPY --from=builder "/app/${TARGETPLATFORM}" /app
ENTRYPOINT [ "/app" ]
