# Standalone Kafka in Docker.

This repository provides everything to build and release the [ctxswitch/kafka](https://hub.docker.com/r/ctxswitch/kafka/) kafka containers. These containers profide a standalone kafka environment for integration testing or local transient message queues.

## Run

##### Start the container

```
# docker run -p 2181:2181 -p 9092:9092 -p 9998 --env DELETE_TOPIC=true ctxswitch/kafka
```

If you have java and the kafka administrative shell scripts you can try creating a topic, publishing some messages to it, and consume.

##### Try creating a topic

```
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test --partitions 1 --replication-factor 1
```

##### Try publishing some messages to the topic

```
./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test < <(seq -f "%03g" 100)       
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
