#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant SNMP2MQTT Add-on
# Displays a simple add-on banner on startup
# ==============================================================================

if bashio::supervisor.ping; then
  bashio::log.blue \
    '-----------------------------------------------------------'
  bashio::log.blue " Add-on: $(bashio::addon.name)"
  bashio::log.blue " $(bashio::addon.description)"
  bashio::log.blue \
    '-----------------------------------------------------------'
  bashio::log.blue " Add-on version: $(bashio::addon.version)"
  if bashio::var.true "$(bashio::addon.update_available)"; then
    bashio::log.magenta ' There is an update available for this add-on!'
    bashio::log.magenta \
        " Latest add-on version: $(bashio::addon.version_latest)"
    bashio::log.magenta ' Please consider upgrading as soon as possible.'
  else
    bashio::log.green ' You are running the latest version of this add-on.'
  fi

  bashio::log.blue " System: $(bashio::info.operating_system)" \
    " ($(bashio::info.arch) / $(bashio::info.machine))"
  bashio::log.blue " Home Assistant Core: $(bashio::info.homeassistant)"
  bashio::log.blue " Home Assistant Supervisor: $(bashio::info.supervisor)"

  bashio::log.blue \
    '-----------------------------------------------------------'
  bashio::log.blue \
    ' Please, share the above information when looking for help'
  bashio::log.blue \
    ' or support in, e.g., GitHub, forums or the Discord chat.'
  bashio::log.blue \
    '-----------------------------------------------------------'
fi

# ==============================================================================

CONFIG_PATH=/data/options.json
TARGET_PATH="$(bashio::config 'targets_path')"

if [ -z "$TARGET_PATH" ]; then
  TARGET_PATH="/config/addons_config/snmp2mqtt/targets.yaml"
  bashio::log.notice 'Switch to default file with Targets:'
  bashio::log.notice " ${TARGET_PATH}"
fi

if [ ! -f "$TARGET_PATH" ]; then
  bashio::log.fatal
  bashio::log.fatal 'Configuration of this add-on is incomplete.'
  bashio::log.fatal
  bashio::log.fatal 'File with Targets config not found:'
  bashio::log.fatal " ${TARGET_PATH}"
  bashio::log.fatal
  bashio::exit.nok
fi

bashio::log.info 'SNMP2MQTT Starting...'

bashio::log.info 'Prepare config...'
yq -p json -o yaml $CONFIG_PATH > /app/config.main
grep -v "targets_path" /app/config.main > /app/config.yml
cat $TARGET_PATH >> /app/config.yml

bashio::log.info
bashio::log.info 'Configuration - Targets from:'
bashio::log.blue "                  ${TARGET_PATH}"
bashio::log.info 'Configuration - MQTT Host:'
bashio::log.blue "                  $(bashio::config 'mqtt.host')"
bashio::log.info 'SNMP2MQTT Start'
bashio::log.info

# ==============================================================================

bashio::color.blue
node /app/dist/index.js
bashio::color.reset

# ==============================================================================

bashio::log.info
bashio::log.info 'SNMP2MQTT Stop'
bashio::exit.ok
