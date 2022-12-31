FROM debian:latest
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt install --no-install-recommends -y cron jq curl ca-certificates

RUN mkdir -p /opt/cardano/shared/logs
RUN mkdir -p /opt/cardano/shared/configs

WORKDIR /opt/cardano/scripts
COPY scripts .
RUN chmod 750 *.sh

CMD ["./entrypoint.sh"]
