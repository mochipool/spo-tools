#!/bin/bash

SNAPSHOT=$(cardano-cli query stake-snapshot --stake-pool-id cat /shared/common/priv/pool/mochi/pool.id --mainnet)
/home/westbam/.cargo/bin/cncli sync --host 127.0.0.1 --port 6000 --no-service
POOL_STAKE=$(echo "$SNAPSHOT" | grep -oP '(?<=    "poolStakeMark": )\d+(?=,?)')
ACTIVE_STAKE=$(echo "$SNAPSHOT" | grep -oP '(?<=    "activeStakeMark": )\d+(?=,?)')
MOCHI=`cncli leaderlog --pool-id $(cat /shared/common/priv/pool/mochi/pool.id) --pool-vrf-skey /shared/common/priv/pool/mochi/vrf.skey --byron-genesis /opt/cnode/configs/byron-genesis.json --shelley-genesis /opt/cnode/configs/shelley-genesis.json --pool-stake $POOL_STAKE --active-stake $ACTIVE_STAKE --consensus praos --ledger-set next`

EPOCH=`echo $MOCHI | jq .epoch`
SLOTS=`echo $MOCHI | jq .epochSlots`
IDEAL=`echo $MOCHI | jq .epochSlotsIdeal`
PERFORMANCE=`echo $MOCHI | jq .maxPerformance`

echo "MOCHI" | tee -a "${LOG_DIR}"/leaderlog.txt
echo "\`Epoch $EPOCH\` 🧙🔮:" | tee -a "${LOG_DIR}"/leaderlog.txt
echo "\`MOCHI  - $SLOTS \`🎰\`,  $PERFORMANCE% \`🍀max, \`$IDEAL\` 🧱ideal" | tee -a "${LOG_DIR}"/leaderlog.txt