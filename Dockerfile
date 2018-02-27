# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM openjdk:8

ARG HADOOP_VERSION
ARG ZOOKEEPER_VERSION
ARG ACCUMULO_VERSION
ARG FLUO_VERSION

ARG HADOOP_HASH
ARG ZOOKEEPER_HASH
ARG ACCUMULO_HASH
ARG FLUO_HASH

ENV HADOOP_VERSION ${HADOOP_VERSION:-2.7.5}
ENV ZOOKEEPER_VERSION ${ZOOKEEPER_VERSION:-3.4.11}
ENV ACCUMULO_VERSION ${ACCUMULO_VERSION:-1.8.1}
ENV FLUO_VERSION ${FLUO_VERSION:-1.2.0}

ENV HADOOP_HASH ${HADOOP_HASH:-0f90ef671530c2aa42cde6da111e8e47e9cd659e}
ENV ZOOKEEPER_HASH ${ZOOKEEPER_HASH:-9268b4aed71dccad3d7da5bfa5573b66d2c9b565}
ENV ACCUMULO_HASH ${ACCUMULO_HASH:-8e6b4f5d9bd0c41ca9a206e876553d8b39923528}
ENV FLUO_HASH ${FLUO_HASH:-a89cb7f76007e8fdd0860a4d5c4e1743d1a30459}

# Download from Apache mirrors instead of archive #9
ENV APACHE_DIST_URLS \
  https://www.apache.org/dyn/closer.cgi?action=download&filename= \
# if the version is outdated (or we're grabbing the .asc file), we might have to pull from the dist/archive :/
  https://www-us.apache.org/dist/ \
  https://www.apache.org/dist/ \
  https://archive.apache.org/dist/

RUN set -eux; \
  download_bin() { \
    local f="$1"; shift; \
    local hash="$1"; shift; \
    local distFile="$1"; shift; \
    local success=; \
    local distUrl=; \
    for distUrl in $APACHE_DIST_URLS; do \
      if wget -nv -O "$f" "$distUrl$distFile"; then \
        success=1; \
        # Checksum the download
        echo "$hash" "*$f" | sha1sum -c -; \
        break; \
      fi; \
    done; \
    [ -n "$success" ]; \
  };\
   \
   download_bin "hadoop.tar.gz" "$HADOOP_HASH" "hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"; \
   download_bin "zookeeper.tar.gz" "$ZOOKEEPER_HASH" "zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz"; \
   download_bin "accumulo.tar.gz" "$ACCUMULO_HASH" "accumulo/$ACCUMULO_VERSION/accumulo-$ACCUMULO_VERSION-bin.tar.gz"; \
   download_bin "fluo.tar.gz" "$FLUO_HASH" "fluo/fluo/$FLUO_VERSION/fluo-$FLUO_VERSION-bin.tar.gz";

RUN tar xzf hadoop.tar.gz -C /tmp/
RUN tar xzf zookeeper.tar.gz -C /tmp/
RUN tar xzf accumulo.tar.gz -C /tmp/
RUN tar xzf fluo.tar.gz -C /tmp/

RUN mv /tmp/hadoop-$HADOOP_VERSION /opt/hadoop
RUN mv /tmp/zookeeper-$ZOOKEEPER_VERSION /opt/zookeeper
RUN mv /tmp/accumulo-$ACCUMULO_VERSION /opt/accumulo
RUN mv /tmp/fluo-$FLUO_VERSION /opt/fluo

ENV HADOOP_PREFIX /opt/hadoop
ENV ZOOKEEPER_HOME /opt/zookeeper
ENV ACCUMULO_HOME /opt/accumulo
ENV FLUO_HOME /opt/fluo
ENV PATH "$PATH:$FLUO_HOME/bin"

RUN /opt/fluo/lib/fetch.sh extra

ENTRYPOINT ["fluo"]
CMD ["help"]
