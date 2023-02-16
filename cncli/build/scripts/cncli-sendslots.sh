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

function sendSlots() {
    cncli sendslots \
        --db ${CNODE_HOME}/common/cncli/db/cncli.db \
        --byron-genesis /opt/cnode/configs/byron-genesis.json \
        --shelley-genesis /opt/cnode/configs/shelley-genesis.json \
        --config ${CNODE_HOME}/common/cncli/pooltool.json
}

statusRet=$(getStatus)

if [[ "$statusRet" == "ok" ]]; then
    mv ${LOG_DIR}/sendslots.log {$LOG_DIR}/sendslots."$(date +%F-%H%M%S)".log
    sendSlots > ${LOG_DIR}/sendslots.log
    find . -name "sendslots.*.log" -mtime +15 -exec rm -f '{}' \;
else
    echo "CNCLI database not synced!!!" | tee -a "${LOG_DIR}"/sendslots.log
fi

exit 0