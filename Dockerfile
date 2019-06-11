FROM openjdk:8-stretch
ARG KAFKA_VERSION
ARG SCALA_VERSION

RUN apt-get update \
    && apt-get -y install zookeeper supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && curl https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz \
    |  tar xzf - -C /opt \
    && ln -sf /opt/kafka_$SCALA_VERSION-$KAFKA_VERSION /opt/kafka

ADD scripts/kafka-start.sh /usr/local/bin/
ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

EXPOSE 2181 9092 9998
CMD ["supervisord", "-n"]
