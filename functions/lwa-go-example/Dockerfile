# syntax=docker/dockerfile:1

FROM golang:1.24 AS build

WORKDIR /build
COPY src/go.mod .
COPY src/go.sum .
RUN go mod download
COPY src/ ./
RUN CGO_ENABLED=0 go build -o app .

FROM public.ecr.aws/lambda/provided:al2023 AS runtime

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.0 /lambda-adapter /opt/extensions/lambda-adapter
COPY --from=build /build/app /app

ENV AWS_LWA_PORT="8080"
ENV AWS_LWA_ENABLE_COMPRESSION="true"
ENV AWS_LWA_PASS_THROUGH_PATH="/events"
ENV AWS_LWA_READINESS_CHECK_PATH="/readyz"
ENV AWS_LWA_READINESS_CHECK_PORT="${AWS_LWA_PORT}"

ENTRYPOINT [ "/app" ]
