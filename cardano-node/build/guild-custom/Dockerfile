FROM ubuntu:latest

LABEL desc="Mochi SPO Tools"
ARG DEBIAN_FRONTEND=noninteractive

USER root
WORKDIR /

ENV \
    ENV=/etc/profile \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    CNODE_HOME=/opt/cardano/cnode \
    CARDANO_NODE_SOCKET_PATH=$CNODE_HOME/sockets/node0.socket \
    PATH=/opt/cardano/cnode/scripts:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/home/mochi/.local/bin \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt


RUN set -x && apt update \
    && mkdir -p /root/.local/bin \
    && apt install -y curl wget gnupg apt-utils git udev \
    && wget https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/guild-deploy.sh \
    && export SUDO='N' \
    && export UPDATE_CHECK='N' \
    && export SKIP_DBSYNC_DOWNLOAD='Y' \
    && chmod +x ./guild-deploy.sh &&  ./guild-deploy.sh -b master -s p \
    && mkdir -p $CNODE_HOME/priv/files \
    && apt-get update && apt-get install --no-install-recommends -y locales apt-utils \
    && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc \
    && echo "export LANG=en_US.UTF-8" >> ~/.bashrc \
    && echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashr \
    && apt-get install -y procps libsecp256k1-0 libcap2 libselinux1 libc6 libsodium-dev ncurses-bin iproute2 curl wget apt-utils xz-utils netbase sudo coreutils dnsutils net-tools procps tcptraceroute bc sqlite3 python3 tmux jq ncurses-base libtool autoconf git gnupg tcptraceroute util-linux less openssl bsdmainutils dialog \
    && apt-get -y remove libpq-dev build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ && apt-get -y purge && apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* \
    && cd /usr/bin \
    && wget http://www.vdberg.org/~richard/tcpping \
    && chmod 755 tcpping \
    && adduser --disabled-password --gecos '' mochi \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && adduser mochi sudo 


# Fetch Cardano Node Binaries
RUN curl -sfL https://s3.ap-southeast-1.amazonaws.com/update-cardano-mainnet.iohk.io/cardano-node-releases/cardano-node-1.35.6-linux.tar.gz -o cnode.tar.gz
RUN tar zxf cnode.tar.gz ./cardano-node ./cardano-cli ./cardano-submit-api ./bech32
RUN mv -t /root/.local/bin cardano-node cardano-cli cardano-submit-api bech32 \
    && chmod +x /root/.local/bin/* \
    && rm -f cnode.tar.gz

USER mochi
WORKDIR /home/mochi

# Commit Version
RUN  curl -sL -H "Accept: application/vnd.github.everest-preview+json" -H "Content-Type: application/json" https://api.github.com/repos/cardano-community/guild-operators/commits | grep -v md | grep -A 2 guild-deploy.sh | grep sha | head -n 1 | cut -d "\"" -f 4 > ~/guild-latest.txt \
    && echo "head -n 22 /home/mochi/.scripts/banner.txt" >> ~/.bashrc \
    && echo "grep MENU -A 6 /home/mochi/.scripts/banner.txt | grep -v MENU" >> ~/.bashrc \
    && echo "alias env=/usr/bin/env" >> ~/.bashrc \
    && echo "alias cntools=$CNODE_HOME/scripts/cntools.sh" >> ~/.bashrc \
    && echo "alias gLiveView=$CNODE_HOME/scripts/gLiveView.sh" >> ~/.bashrc \
    && echo "export PATH=/opt/cardano/cnode/scripts:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/home/mochi/.local/bin"  >> ~/.bashrc 

# ENTRY SCRIPT
ADD banner.txt /home/mochi/.scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/docker/node/addons/guild-topology.sh /home/mochi/.scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/docker/node/addons/block_watcher.sh /home/mochi/.scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/docker/node/addons/healthcheck.sh /home/mochi/.scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/guild-deploy.sh /opt/cardano/cnode/scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/docker/node/addons/entrypoint.sh ./

RUN sudo chown -R mochi:mochi $CNODE_HOME/* \
    && mkdir /home/mochi/.local/ \
    && sudo mv /root/.local/bin /home/mochi/.local/ \
    && sudo chown -R mochi:mochi /home/mochi/.* \
    && sudo chmod a+x /home/mochi/.scripts/*.sh /opt/cardano/cnode/scripts/*.sh /home/mochi/entrypoint.sh

HEALTHCHECK --start-period=5m --interval=5m --timeout=100s CMD /home/mochi/.scripts/healthcheck.sh

CMD [ "./entrypoint.sh" ]
