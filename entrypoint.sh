#!/bin/bash

export PGPASSWORD="${DB_PASSWORD}"

osm2pgsql -U ${DB_USER:-renderer} -H ${DB_HOST:-localhost} -d ${DB_NAME:-gis} -P ${DB_PORT:-5432} --create --slim -G --hstore --tag-transform-script /openstreetmap-carto.lua --number-processes ${THREADS:-$(nproc)} -S /openstreetmap-carto.style /data.osm.pbf
