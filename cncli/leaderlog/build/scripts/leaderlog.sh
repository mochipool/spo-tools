#!/bin/bash

SNAPSHOT=$(cardano-cli query stake-snapshot --stake-pool-id $(cat ${CNODE_HOME}/priv/pool/pool.id) --mainnet)
POOL_STAKE=$(echo "$SNAPSHOT" | grep -oP '(?<=    "poolStakeMark": )\d+(?=,?)')
ACTIVE_STAKE=$(echo "$SNAPSHOT" | grep -oP '(?<=    "activeStakeMark": )\d+(?=,?)')
MOCHI=`cncli leaderlog \
    --db ${CNODE_HOME}/cncli/db/cncli.db \
    --pool-id $(cat ${CNODE_HOME}/priv/pool/pool.id) \
    --pool-vrf-skey ${CNODE_HOME}/priv/pool/keys/vrf.skey \
    --byron-genesis ${CNODE_HOME}/configs/byron-genesis.json \
    --shelley-genesis ${CNODE_HOME}/configs/shelley-genesis.json \
    --pool-stake $POOL_STAKE \
    --active-stake $ACTIVE_STAKE \
    --consensus praos \
    --ledger-set current`

EPOCH=`jq .epoch <<< $MOCHI`

SLOTS=`jq .epochSlots <<< $MOCHI`
IDEAL=`jq .epochSlotsIdeal <<< $MOCHI`
PERFORMANCE=`jq .maxPerformance <<< $MOCHI`

echo "MOCHI" | tee -a ${LOG_DIR}/leaderlog.log
echo "\`Epoch $EPOCH\` 🧙🔮:" | tee -a ${LOG_DIR}/leaderlog.log
echo "\`MOCHI  - $SLOTS \`🎰\`,  $PERFORMANCE% \`🍀max, \`$IDEAL\` 🧱ideal" | tee -a ${LOG_DIR}/leaderlog.log