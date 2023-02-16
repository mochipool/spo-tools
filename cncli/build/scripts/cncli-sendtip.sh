#!/bin/bash bash

CNODE_HOME="/opt/cardano/shared"
LOG_DIR="${CNODE_HOME}/logs"

function getStatus() {
    local result
    result=$(cncli status \
        --db ${CNODE_HOME}/common/cncli/db/cncli.db \
        --byron-genesis /opt/cnode/configs/byron-genesis.json \
        --shelley-genesis /opt/cnode/configs/shelley-genesis.json \
        | jq -r .status
    )
    echo "$result"
}

function sendTip() {
    cncli sendtip \
        --cardano-node /usr/local/bin/cardano-node \
        --config ${CNODE_HOME}/common/cncli/pooltool/pooltool.json
}

statusRet=$(getStatus)

if [[ "$statusRet" == "ok" ]]; then
    mv ${LOG_DIR}/sendtip.log {$LOG_DIR}/sendtip."$(date +%F-%H%M%S)".log
    sendTip > ${LOG_DIR}/sendtip.log
    find . -name "sendtip.*.log" -mtime +15 -exec rm -f '{}' \;
else
    echo "CNCLI database not synced!!!" | tee -a "${LOG_DIR}"/sendslots.log
fi

exit 0