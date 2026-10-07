FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        coreutils \
        iproute2 \
        iputils-ping \
        netcat-openbsd \
        procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY app/ /app/

RUN chmod +x /app/app.sh

ENTRYPOINT ["/app/app.sh"]

CMD ["help"]
