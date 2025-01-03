#!/bin/bash
set -e

rpk topic create -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER} mqtt-messages
rpk topic create -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER} mqtt-sessions --topic-config cleanup.policy=compact
rpk topic create -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER} mqtt-retained --topic-config cleanup.policy=compact
rpk topic create -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER} mqtt-devices --topic-config cleanup.policy=compact
