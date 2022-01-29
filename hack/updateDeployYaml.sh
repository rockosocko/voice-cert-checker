#!/bin/bash


if ! helm version -c --short | grep -E "v3." >/dev/null; then
    echo "Helm v3 is needed!"
    exit 1
fi

helm template voice-cert-checker deploy/charts/voice-cert-checker --no-hooks --set image.pullPolicy=Always  \
    --set ingress.enabled=true  \
    --set ingress.hosts[0].host=voice-cert-checker.localtest.me  \
    --set ingress.hosts[0].paths[0].path="/" \
    --set image.pullPolicy=IfNotPresent \
    | grep -vi helm \
    | grep -vi chart \
    | grep -v "# Source" \
    | grep -v "checksum/config" > deploy/yaml/deploy.yaml

helm template voice-cert-checker deploy/charts/voice-cert-checker --no-hooks -s templates/grafana-dashboard-cm.yaml --set grafanaDashboard.enabled=true  \
    | grep -vi helm \
    | grep -vi chart \
    | grep -v "# Source" \
    | grep -v "checksum/config" > deploy/yaml/grafana-dashboard-cm.yaml

helm template voice-cert-checker deploy/charts/voice-cert-checker --no-hooks -s templates/servicemonitor.yaml \
    --set serviceMonitor.enabled=true  \
    --set serviceMonitor.additionalLabels.release=prometheus  \
    | grep -vi helm \
    | grep -vi chart \
    | grep -v "# Source" \
    | grep -v "checksum/config" > deploy/yaml/servicemonitor.yaml

cp deploy/charts/voice-cert-checker/dashboards/voice-cert-checker.json deploy/docker-compose/grafana/provisioning/dashboards/voice-cert-checker.json
