FROM ubuntu:18.04 AS build-osm2pgsql

RUN apt-get update && apt-get install -y git build-essential cmake autoconf osmosis libxml2-dev libexpat1-dev bzip2 libbz2-dev liblua5.3-dev libboost-filesystem-dev libboost-system-dev

RUN apt-get update \
  && apt-get install wget gnupg2 lsb-core -y \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb [ trusted=yes ] https://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
  && apt-get update

RUN apt-get update && apt-get install -y postgresql-server-dev-12

RUN git clone https://github.com/openstreetmap/osm2pgsql.git && \
    cd osm2pgsql && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j $(nproc) && \
    make install



FROM ubuntu:18.04 AS stylesheet

RUN apt-get update && apt-get install -y curl
RUN curl -L https://github.com/gravitystorm/openstreetmap-carto/archive/v4.23.0.tar.gz | tar -zxf - && \
    mv openstreetmap-carto-4.23.0 openstreetmap-carto



FROM ubuntu:18.04

COPY --from=build-osm2pgsql /usr/lib/x86_64-linux-gnu/*.so.* /usr/lib/x86_64-linux-gnu/
COPY --from=build-osm2pgsql /lib/x86_64-linux-gnu/*.so.* /lib/x86_64-linux-gnu/
COPY --from=build-osm2pgsql /usr/local/bin/osm2pgsql /usr/local/bin/osm2pgsql

RUN ldconfig

COPY --from=stylesheet /openstreetmap-carto/openstreetmap-carto.lua /openstreetmap-carto.lua
COPY --from=stylesheet /openstreetmap-carto/openstreetmap-carto.style /openstreetmap-carto.style

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
