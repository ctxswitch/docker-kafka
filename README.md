# Standalone Kafka in Docker.

This repository provides everything to build and release the [ctxswitch/kafka](https://hub.docker.com/r/ctxswitch/kafka/) kafka containers. These containers profide a standalone kafka environment for integration testing or local transient message queues.

## Run

##### Start the container

```
# docker run -p 2181:2181 -p 9092:9092 -p 9998 --env DELETE_TOPIC=true --name kafka ctxswitch/kafka
```

The bin directory contains some wrappers that allow you to run administrative commands through the same container images that you are running the server with.  This interactive session requires you to either name the container running the server as `kafka` or set the `KAFKA_CONTAINER_NAME` environment variable to the name of the appropriate container.

##### Try creating a topic

```
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test --partitions 1 --replication-factor 1
```

##### Try publishing some messages to the topic

```
seq -f "%03g" 100 | ./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test     
```

##### Try consuming the messages

```
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --offset earliest --partition 0 --topic test
```

##### Clean up the topic

```
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic test
```

## Environment Variables

* `ADVERTISED_HOST` - Default: localhost
* `ADVERTISED_PORT` - Default: 9092
* `AUTO_CREATE_TOPICS` - Default: true
* `DELETE_TOPIC` - Default: false
* `KAFKA_HEAP_OPTS` - Default: -Xmx256M
* `KAFKA_JVM_PERFORMANCE_OPTS` - Default: -server -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -Djava.awt.headless=true
* `LOG_RETENTION_HOURS` - Default: 1
* `LOG_RETENTION_BYTES` - Default: 1024000
* `NUM_PARTITIONS` - Default: 4
