# syntax=docker/dockerfile:1

FROM denoland/deno:bin-1.46.3 AS deno
FROM public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 AS aws-lambda-adapter
FROM debian:bookworm-slim AS runtime

ARG TARGETOS="linux"
ARG TARGETARCH="arm64"

RUN \
    apt-get update && \
    apt-get install --yes --quiet curl unzip && \
    if [ "${TARGETARCH}" = "amd64" ]; then export AWS_ARCH="x86_64" ; fi && \
    if [ "${TARGETARCH}" = "arm64" ]; then export AWS_ARCH="aarch64" ; fi && \
    curl \
        --fail \
        --silent \
        --location \
        --output "awscliv2.zip" \
        "https://awscli.amazonaws.com/awscli-exe-${TARGETOS}-${AWS_ARCH}.zip" && \
    unzip -qq awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws/install awscliv2.zip && \
    apt-get purge --yes --quiet curl unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=aws-lambda-adapter /lambda-adapter /opt/extensions/lambda-adapter
COPY --from=deno /deno /usr/local/bin/deno

RUN mkdir /var/deno_dir
ENV DENO_DIR=/var/deno_dir
ENV AWS_LWA_PORT=8080
EXPOSE 8080

COPY . /var/task
WORKDIR /var/task

# Warmup caches
RUN timeout 10s deno run -A main.ts || [ $? -eq 124 ] || exit 1

CMD ["deno", "run", "-A", "main.ts"]
