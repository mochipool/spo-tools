#!/bin/bash
echo "Starting CNCLI SendTip Service"
while true; 
do 
    cncli sendtip --cardano-node /usr/local/bin/cardano-node --config ${CNODE_HOME}/cncli/pooltool/pooltool.json
    sleep 10;
done;
echo "Service Terminated"