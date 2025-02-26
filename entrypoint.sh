#!/bin/bash

# Check if this is the first server, or if retrying join with other servers
if [ ! -f /consul/config/consul.json ]; then
    echo "Consul configuration not found, bootstrapping a new cluster..."
    consul agent -server -ui -data-dir=/consul/data -config-dir=/consul/config -bootstrap-expect=${CONSUL_BOOTSTRAP_EXPECT} -client=0.0.0.0 -bind=0.0.0.0 &
else
    echo "Joining the cluster..."
    consul agent -server -ui -data-dir=/consul/data -config-dir=/consul/config -retry-join=$CONSUL_RETRY_JOIN -client=0.0.0.0 -bind=0.0.0.0 &
fi

# Wait for Consul to start
wait
