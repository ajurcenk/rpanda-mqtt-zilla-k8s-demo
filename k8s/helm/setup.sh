#!/bin/bash
set -e

ZILLA_VERSION="${ZILLA_VERSION:-^0.9.0}"
ZILLA_CHART="${ZILLA_CHART:-oci://ghcr.io/aklivity/charts/zilla}"
ZILLA_YAML=zilla.yaml


if [[ $KAFKA_SCRAM_WITH_TLS == true ]]; then
  ZILLA_YAML=zilla_scram_tls.yaml
fi

# Install Zilla to the Kubernetes cluster with helm and wait for the pod to start up
# echo "==== Installing $ZILLA_CHART to $NAMESPACE with $KAFKA_BOOTSTRAP_SERVER ===="
# helm upgrade --install zilla $ZILLA_CHART --version $ZILLA_VERSION --namespace $NAMESPACE --create-namespace --wait \
#     --values values.yaml \
#     --set env.KAFKA_BOOTSTRAP_SERVER="$KAFKA_BOOTSTRAP_SERVER" \
#     --set-file zilla\\.yaml=../../zilla.yaml \
#     --set-file secrets.tls.data.localhost\\.p12=../../tls/localhost.p12 \
#     --set-file secrets.tls.data.ca\\.crt=../../tls/test-ca.crt


helm upgrade --install zilla $ZILLA_CHART --version $ZILLA_VERSION --namespace $NAMESPACE --create-namespace --wait \
    --values values.yaml \
    --set env.KAFKA_BOOTSTRAP_SERVER="$KAFKA_BOOTSTRAP_SERVER" \
    --set-file zilla\\.yaml=../../${ZILLA_YAML} \
    --set-file secrets.tls.data.localhost\\.p12=../../tls/localhost.p12 \
    --set-file secrets.tls.data.truststore\\.jks=../../tls/truststore.jks


# # Start port forwarding
# SERVICE_PORTS=$(kubectl get svc --namespace $NAMESPACE zilla --template "{{ range .spec.ports }}{{.port}} {{ end }}")
# eval "kubectl port-forward --namespace $NAMESPACE service/zilla $SERVICE_PORTS" > /tmp/kubectl-zilla.log 2>&1 &

# if [[ -x "$(command -v nc)" ]]; then
#     until nc -z localhost 7183; do sleep 1; done
#     until nc -z localhost 7883; do sleep 1; done
# fi
