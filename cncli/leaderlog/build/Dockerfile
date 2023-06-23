FROM ubuntu:latest

LABEL desc="Mochi CNCLI Tools"
ARG DEBIAN_FRONTEND=noninteractive
ARG CNODE_VERSION=8.1.1
ARG CNCLI_VERSION=5.3.2

USER root
WORKDIR /

# Setup
RUN apt-get update && apt-get install --no-install-recommends -y locales apt-utils wget jq curl bc xxd git vim usbutils ca-certificates procps gnupg cron
RUN mkdir -p /opt/cnode/priv/wallets /opt/cnode/ipc /opt/cnode/configs /opt/cnode/scripts

# Fetch Cardano CLI Binaries
RUN wget https://github.com/input-output-hk/cardano-node/releases/download/$CNODE_VERSION/cardano-node-$CNODE_VERSION-linux.tar.gz \
    && tar -xvf cardano-node-$CNODE_VERSION-linux.tar.gz -C /usr/local/bin \
    && rm cardano-node-$CNODE_VERSION-linux.tar.gz

# Fetch CNCLI
RUN wget https://github.com/cardano-community/cncli/releases/download/v$CNCLI_VERSION/cncli-$CNCLI_VERSION-x86_64-unknown-linux-musl.tar.gz \
    && tar -xzf cncli-$CNCLI_VERSION-x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin/ \
    && rm cncli-$CNCLI_VERSION-x86_64-unknown-linux-musl.tar.gz

# Fetch Mainnet Configs
WORKDIR /opt/cnode/configs
RUN wget https://book.world.dev.cardano.org/environments/mainnet/config.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/db-sync-config.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/submit-api-config.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/topology.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/byron-genesis.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/shelley-genesis.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/alonzo-genesis.json \
    && wget https://book.world.dev.cardano.org/environments/shelley-qa/conway-genesis.json

# Entrypoint Scripts
WORKDIR /opt/cardano/scripts
COPY scripts .
RUN chmod 750 *.sh

CMD ["./entrypoint.sh"]
