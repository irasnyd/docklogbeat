docklogbeat
===========

`docklogbeat` is a tool which combines [filebeat](https://www.elastic.co/products/beats/filebeat)
and [docker-gen](https://github.com/jwilder/docker-gen) to transport data
from Docker container logs to Logstash and Elasticsearch.

It is intended as a more reliable replacement for [logspout](https://github.com/gliderlabs/logspout).

The implementation was inspired by [this blog post](http://www.sandtable.com/forwarding-docker-logs-to-logstash/).

Instructions
============

Run the `docklogbeat` container on each physical host in your cluster. It will
watch for new Docker containers to be spawned. If a container has a specific
label, it will automatically begin shipping the logs to your Logstash or
Elasticsearch cluster.

An example:

    $ docker run -d \
        -v /var/lib/docker:/var/lib/docker:ro \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e LOGSTASH_HOSTS=logstash1.example.com:5044,logstash2.example.com:5044 \
        docklogbeat

Any containers with the label `docklogbeat=true` will have their Docker logs
sent to the configured Logstash / Elasticsearch cluster.

An example:

    $ docker run -l docklogbeat=true ...

Limitations
===========

The `docker-gen` tool takes about 2 seconds to notice new containers and
regenerate the `filebeat` configuration. If your containers are short lived,
they may not have their log output sent to your Logstash / Elasticsearch cluster.

This container will read all log messages from Log Producing Containers when it
starts, similar to `docker logs --tail=all`. If you need to restart `docklogbeat`
without producing duplicate messages, you must make sure to store
`/var/lib/filebeat/registry` on a persistent volume.

Environment Variables
========================================

These environment variables can be used to configure the `docklogbeat` container.

- **`LOGSTASH_HOSTS`** - A comma-separated lists of the Elastic Beats servers which will receive logs.
- **`DOCKLOGBEAT_LABEL_KEY`** - Container Filter Label Key (default: `docklogbeat`).
- **`DOCKLOGBEAT_LABEL_VALUE`** - Container Filter Label Value (default: `true`).

Labels for Log Producing Containers
===================================

- **`docklogbeat`** - must be set to `true` for docklogbeat to collect this container's logs.
- **`docklogbeat_document_type`** - set the `document_type` field for this container (optional).
