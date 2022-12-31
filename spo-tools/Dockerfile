FROM debian:stable-slim

LABEL desc="Mochi SPO Tools"
ARG DEBIAN_FRONTEND=noninteractive

USER root
WORKDIR /

# Setup
RUN apt-get update && apt-get install --no-install-recommends -y locales apt-utils wget jq curl bc xxd git vim usbutils ca-certificates procps
RUN mkdir -p /shared/common /shared/common/priv/wallets /ipc /opt/cnode/configs

# Cosmetic Changes (zsh)
RUN apt-get update && apt install -y zsh 
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Fetch Cardano Node Binaries
ARG CNODE_VERSION=1.35.4
RUN wget https://update-cardano-mainnet.iohk.io/cardano-node-releases/cardano-node-$CNODE_VERSION-linux.tar.gz \
    && tar -xvf cardano-node-$CNODE_VERSION-linux.tar.gz -C /usr/local/bin \
    && rm cardano-node-$CNODE_VERSION-linux.tar.gz

# Fetch Cardano HW CLI
RUN wget https://github.com/vacuumlabs/cardano-hw-cli/releases/download/v1.12.0/cardano-hw-cli-1.12.0_linux-x64.tar.gz \
    && tar -xzf cardano-hw-cli-1.12.0_linux-x64.tar.gz -C /tmp \
    && rm cardano-hw-cli-1.12.0_linux-x64.tar.gz \
    && mv /tmp/cardano-hw-cli/* /usr/local/bin/ \
    && rm -rf tmp/cardano-hw-cli

# Pull SPO scripts
RUN mkdir -p $HOME/stakepoolscripts \
    && cd $_ \
    && cd $HOME/stakepoolscripts \
    && git init \
    && git config http.sslVerify false \
    && git init \
    && git remote add origin https://github.com/gitmachtl/scripts.git \
    && git fetch origin && git reset --hard origin/master \
    && cp cardano/mainnet/* /usr/local/bin/ \
    && cd $HOME \
    && rm -rf $HOME/stakepoolscripts

# Modify SPO script configs
WORKDIR /usr/local/bin
ARG SPO_CONFIG_FILE=00_common.sh
ENV SOCKET_PATH=/ipc/node.socket
RUN sed -i 's/socket="[^"]*"/socket=$SOCKET_PATH/' $SPO_CONFIG_FILE \
    && sed -i 's/cardanocli="[^"]*"/cardanocli="cardano-cli"/' $SPO_CONFIG_FILE \
    && sed -i 's/cardanohwcli="[^"]*"/cardanohwcli="cardano-hw-cli"/' $SPO_CONFIG_FILE \
    && sed -i 's/cardanonode="[^"]*"/cardanonode="cardano-node"/' $SPO_CONFIG_FILE \
    && sed -i 's/bech32_bin="[^"]*"/bech32_bin="bech32"/' $SPO_CONFIG_FILE \
    && sed -i 's+genesisfile="[^"]*"+genesisfile="/opt/cnode/configs/shelley-genesis.json"+' $SPO_CONFIG_FILE \
    && sed -i 's+genesisfile_byron="[^"]*"+genesisfile_byron="/opt/cnode/configs/byron-genesis.json"+' $SPO_CONFIG_FILE \
    && sed -i 's+offlineFile="[^"]*"+offlineFile="/shared/common/offlineTransfer.json"+' $SPO_CONFIG_FILE 

# Fetch Mainnet Configs
WORKDIR /opt/cnode/configs
RUN wget https://book.world.dev.cardano.org/environments/mainnet/config.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/db-sync-config.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/submit-api-config.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/topology.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/byron-genesis.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/shelley-genesis.json \
    && wget https://book.world.dev.cardano.org/environments/mainnet/alonzo-genesis.json

WORKDIR /shared/common/priv
CMD [ "zsh" ]
