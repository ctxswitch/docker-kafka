#!/bin/bash
# Copyright 2019 Rob Lyon (ctxswitch)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. 

KAFKA_HOME="/opt/kafka"
KAFKA_JMX_OPTS="\
  -Dcom.sun.management.jmxremote=true \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Djava.rmi.server.hostname=localhost \
  -Djava.net.preferIPv4Stack=true"
KAFKA_HEAP_OPTS=${KAFKA_HEAP_OPTS:--Xmx256M}
KAFKA_JVM_PERFORMANCE_OPTS=${KAFKA_JVM_PERFORMANCE_OPTS:--server -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -Djava.awt.headless=true}
JMX_PORT="9998"

export KAFKA_HOME KAFKA_JMX_OPTS KAFKA_HEAP_OPTS KAFKA_JVM_PERFORMANCE_OPTS JMX_PORT

ADVERTISED_HOST=${ADVERTISED_HOST:-localhost}
ADVERTISED_PORT=${ADVERTISED_PORT:-9092}
AUTO_CREATE_TOPICS=${AUTO_CREATE_TOPICS:-true}
DELETE_TOPIC=${DELETE_TOPIC:-false}
NUM_PARTITIONS=${NUM_PARTITIONS:-4}
LOG_RETENTION_HOURS=${LOG_RETENTION_HOURS:-1}
LOG_RETENTION_BYTES=${LOG_RETENTION_BYTES:1024000}

cat > /opt/kafka/config/server.properties << EOF
advertised.host.name=$ADVERTISED_HOST
advertised.port=$ADVERTISED_PORT
delete.topic.enable=$DELETE_TOPIC
num.partitions=$NUM_PARTITIONS
auto.create.topics.enable=$AUTO_CREATE_TOPICS
log.retention.hours=$LOG_RETENTION_HOURS
log.retention.byts=$LOG_RETENTION_BYTES
zookeeper.connect=localhost:2181
EOF

$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
