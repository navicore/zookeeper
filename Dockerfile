FROM java:8-alpine
RUN echo "@community http://dl-3.alpinelinux.org/alpine/v3.6/community" >> /etc/apk/repositories

RUN apk add --update -U curl bash tar gzip shadow@community

RUN curl -s -L https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 -o /usr/local/bin/confd; chmod 0755 /usr/local/bin/confd; mkdir -p /etc/confd/{conf.d,templates}

RUN mkdir -p /usr/local/sbin && curl -s -L https://github.com/tianon/gosu/releases/download/1.6/gosu-amd64 -o /usr/local/sbin/gosu; chmod 0755 /usr/local/sbin/gosu

ENV ZOOKEEPER_VERSION 3.4.9

COPY ./start.sh /app/start.sh

RUN chmod +x /app/start.sh

RUN mkdir -p /opt/zookeeper/conf && curl -sS http://apache.claz.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xzf - -C /opt && mv /opt/zookeeper-* /opt/zookeeper && chown -R root:root /opt/zookeeper

RUN groupadd -r zookeeper && useradd -c "Zookeeper" -d /var/lib/zookeeper -g zookeeper -M -r -s /sbin/nologin zookeeper && mkdir /var/lib/zookeeper && chown -R zookeeper:zookeeper /var/lib/zookeeper

EXPOSE 2181 2888 3888

ENTRYPOINT ["/app/start.sh"]

