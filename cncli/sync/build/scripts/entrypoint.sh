#!/bin/bash
echo "Starting CNCLI Sync Service"
cncli sync --host $NODE_HOST --port $NODE_PORT --db ${CNODE_HOME}/cncli/db/cncli.db
echo "Service Terminated"