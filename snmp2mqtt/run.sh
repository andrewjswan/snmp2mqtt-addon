#!/usr/bin/with-contenv bashio

echo "[$(date)][INFO] SNMP2MQTT start"

CONFIG_PATH=/data/options.json

yq -p json -o yaml /data/options.json > /app/config.yml

MQTT_SERVER="$(jq --raw-output '.mqtt.host' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - MQTT Host: $MQTT_SERVER"
