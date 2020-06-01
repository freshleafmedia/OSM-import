# Open Street Map Tile Server Import

## Build

```
docker build .
```

## Run

```
docker run -it --rm -v /path/to/map/data.osm.pbf:/data.osm.pbf freshleafmedia/osm-import
```

### Environment Variables

There are a couple of environment variables used to configure where the Postgis DB is and how to authenticate

- `DB_HOSTNAME` (default is `localhost`)
- `DB_PORT` (default is 5432)
- `DB_USER` (default is `renderer`)
- `DB_PASSWORD`
- `DB_NAME` (default is `gis`)
- `THREADS` How many threads to use while importing (defaults to the output of `nproc`)
