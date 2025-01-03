#!/bin/bash
set -e

rpk topic delete -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER} mqtt-messages
rpk topic delete -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER} mqtt-sessions 
rpk topic delete -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER} mqtt-retained 
rpk topic delete -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER} mqtt-devices