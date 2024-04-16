# Changelog

All notable changes to this project will be documented in this file, in reverse chronological order by release.

## 1.0.7 - 2024-04-16

- Add 'availability_mode' to `sensors` scheme, valid entries are `all`, `any`, and `latest`. (default: `all`)

## 1.0.5 - 2024-04-15

- Add `template` to target sensor scheme

## 1.0.3 - 2024-04-15

- Hide MQTT username/password in logs

## 1.0.1 - 2024-04-13

- Add `entity_category` to Sensor for Home Assistant
- Add `mac` to Device for Home Assistant connections
- Add `base_topic`, `host_name_as_target` to MQTT settings
- Bump dependencies
- Switch to https://github.com/andrewjswan/snmp2mqtt repository

## 1.0.0 - 2024-04-11

- Initial release.
