# rpanda-mqtt-zilla-k8s-demo

This is the example Redpanda MQTT using [zilla](https://github.com/aklivity/zilla) for Kubernetes deployment.

## Setup

### Export variables

```bash
# The zilla Kubernetes namespace
export NAMESPACE=zilla-mqtt
# The internal Kubernetes Redpanda listener
export KAFKA_BOOTSTRAP_SERVER=redpanda-0.testzone.local:9094
# The external (ouside Kubernetes) Redpanda listener
export KAFKA_BOOTSTRAP_EXTERNAL_SERVER=redpanda-0.testzone.local:31092
# Security flag
export KAFKA_SCRAM_WITH_TLS=false
```

### Create MQTT topics

Creates MQTT topics using Redpanda external lsiteners

```bash
./create_topics
```

### Deploy Zilla MQTT Kafka proxy

### Deploy without Redpanda cluster security: no authentication, no TLS

[The Zilla helm chart](https://github.com/aklivity/zilla/tree/main/cloud/helm-chart/src/main/helm/zilla)

```bash
./setup
```

### Deploy with Redpanda cluster security: SCRAM authentication and TLS

* Create trusted store: `truststore.jks` in `tls` folder
* Add passwords to the `values.yaml`

    ```yaml
    env:
        KEYSTORE_PASSWORD: generated
        SASL_USERNAME: <replace>
        SASL_PASSWORD: <replace>
        TRUSTSTORE_PASSWORD: <replace>
    ```

* Set enviroment variable:

    ```bash
    export KAFKA_SCRAM_WITH_TLS=true
    ```

* Deploy zilla MQTT proxy

    ```bash
    ./setup
    ```

## Test deployment

### Deploy MQTT client pod for testing

```bash
kubectl apply -f ./mqqt_client.yaml -n ${NAMESPACE}
```

### Subscribe to device MQTT channel

```bash
export ZILLA_MQTT_POD_IP=$(kubectl get pods --selector=app.kubernetes.io/name=zilla -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}' -n ${NAMESPACE})

kubectl exec mosquitto-client -n ${NAMESPACE} -- mosquitto_sub -t 'device/01' -d -p 7183 -h ${ZILLA_MQTT_POD_IP}  -V '5'
```

### Produce test MQTT message

```bash
export ZILLA_MQTT_POD_IP=$(kubectl get pods --selector=app.kubernetes.io/name=zilla -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}' -n ${NAMESPACE})

kubectl exec mosquitto-client -n ${NAMESPACE} -- mosquitto_pub -t 'device/01' -d -p 7183 -h ${ZILLA_MQTT_POD_IP}  -V '5'  -m 'Hello-1' 
```

### Check Redpanda topic

```bash
rpk topic consume mqtt-devices -X brokers=${KAFKA_BOOTSTRAP_EXTERNAL_SERVER}

```

## Clean deployment

```bash
./teardown.sh
```

```bash
./delete_topics.sh
```
