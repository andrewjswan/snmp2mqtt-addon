#!/usr/bin/with-contenv bashio

CONFIG_PATH=/data/options.json
TARGET_PATH="$(bashio::config 'targets_path')"

if [ -z "$TARGET_PATH" ]; then
    TARGET_PATH="/config/addons_config/snmp2mqtt/targets.yaml"
fi

if [ ! -f "$TARGET_PATH" ]; then
    echo "[$(date)][ERROR] Targets not found: $TARGET_PATH"
    exit 1
fi

echo "[$(date)][INFO] SNMP2MQTT Start"

echo "[$(date)][INFO] SNMP2MQTT Prepare config file"
yq -p json -o yaml $CONFIG_PATH > /app/config.main
grep -v "targets_path" /app/config.main > /app/config.yml
cat $TARGET_PATH >> /app/config.yml

MQTT_SERVER="$(bashio::config 'mqtt.host')"
echo "[$(date)][INFO] Configuration - Targets from: $TARGET_PATH"
echo "[$(date)][INFO] Configuration - MQTT Host: $MQTT_SERVER"

node /app/dist/index.js

echo "[$(date)][INFO] SNMP2MQTT Stop"
