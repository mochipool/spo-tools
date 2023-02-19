#!/bin/bash

function getStatus() {
    local result
    result=$(cncli status \
        --db ${CNODE_HOME}/cncli/db/cncli.db \
        --byron-genesis ${CNODE_HOME}/configs/byron-genesis.json \
        --shelley-genesis ${CNODE_HOME}/configs/shelley-genesis.json \
        | jq -r .status
    )
    echo "$result"
}

function sendSlots() {
    cncli sendslots \
        --db ${CNODE_HOME}/cncli/db/cncli.db \
        --byron-genesis ${CNODE_HOME}/configs/byron-genesis.json \
        --shelley-genesis ${CNODE_HOME}/configs/shelley-genesis.json \
        --config ${CNODE_HOME}/cncli/pooltool/pooltool.json
}

statusRet=$(getStatus)

if [[ "$statusRet" == "ok" ]]; then
    mv ${LOG_DIR}/sendslots.log ${LOG_DIR}/sendslots."$(date +%F-%H%M%S)".log
    sendSlots > ${LOG_DIR}/sendslots.log
    find . -name "sendslots.*.log" -mtime +15 -exec rm -f '{}' \;
else
    echo "CNCLI database not synced!!!"
fi

exit 0