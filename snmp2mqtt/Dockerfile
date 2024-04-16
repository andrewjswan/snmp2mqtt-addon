ARG BUILD_FROM

### Build snmp2mqtt
FROM node:lts-alpine3.15 AS builder

# Packages
RUN \
  apk add --no-cache --virtual .build-dependencies \
    git

WORKDIR /app

# Clone
ARG SOURCE_REPO=andrewjswan

ADD "https://api.github.com/repos/${SOURCE_REPO}/snmp2mqtt/commits?per_page=1" latest_commit
RUN \
  git clone --branch main --single-branch https://github.com/${SOURCE_REPO}/snmp2mqtt.git /tmp/snmp2mqtt \
  && mkdir -p /app/src \
  && cd /tmp/snmp2mqtt \
  && cp package.json /app \
  && cp yarn.lock /app \
  && cp tsconfig.json /app \
  && cp src/* /app/src

# Build
RUN yarn install --frozen-lockfile
RUN yarn build

RUN mv /app/node_modules /app/node_modules_dev
RUN yarn install --frozen-lockfile --production

### Addon
FROM $BUILD_FROM
STOPSIGNAL SIGINT

# Packages
RUN \
  apk add --no-cache --virtual .build-dependencies \
    yq nodejs npm

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Add Label
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Andrew J.Swan <andrewjswan@addons.community>"

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

# Start snmp2mqtt
WORKDIR /app

COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json

# NPM
RUN \
  cd /app \
  && npm install \
  && npm rebuild

CMD [ "/run.sh" ]
