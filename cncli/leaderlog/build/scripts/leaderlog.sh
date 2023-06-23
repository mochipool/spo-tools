#!/bin/bash

SNAPSHOT=$(cardano-cli query stake-snapshot --stake-pool-id $(cat ${CNODE_HOME}/priv/pool/pool.id) --mainnet)
POOL_STAKE=$(echo $SNAPSHOT | jq '.pools."4e46972f7896ca3361efe216d70f65dbeaa926a693219d74fca43660".stakeMark')
ACTIVE_STAKE=$(echo $SNAPSHOT | jq .total.stakeMark)
MOCHI=`cncli leaderlog \
    --db ${CNODE_HOME}/cncli/db/cncli.db \
    --pool-id $(cat ${CNODE_HOME}/priv/pool/pool.id) \
    --pool-vrf-skey ${CNODE_HOME}/priv/pool/keys/vrf.skey \
    --byron-genesis ${CNODE_HOME}/configs/byron-genesis.json \
    --shelley-genesis ${CNODE_HOME}/configs/shelley-genesis.json \
    --pool-stake 5704575471461 \
    --active-stake 22735339826891192 \
    --consensus praos \
    --ledger-set next`

EPOCH=`jq .epoch <<< $MOCHI`

SLOTS=`jq .epochSlots <<< $MOCHI`
IDEAL=`jq .epochSlotsIdeal <<< $MOCHI`
PERFORMANCE=`jq .maxPerformance <<< $MOCHI`

echo "MOCHI" | tee -a ${LOG_DIR}/leaderlog.log
echo "\`Epoch $EPOCH\` 🧙🔮:" | tee -a ${LOG_DIR}/leaderlog.log
echo "\`MOCHI  - $SLOTS \`🎰\`,  $PERFORMANCE% \`🍀max, \`$IDEAL\` 🧱ideal" | tee -a ${LOG_DIR}/leaderlog.log
echo $MOCHI | tee -a ${LOG_DIR}/leaderlog.log