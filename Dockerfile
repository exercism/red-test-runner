FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
  curl \
  libc6:i386 \
  libcurl4:i386 \
  libgdk-pixbuf2.0-0:i386 && \
  apt-get purge --auto-remove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN curl -L -O http://www.rebol.com/downloads/v278/rebol-core-278-4-10.tar.gz && \
  tar -xzf rebol-core-278-4-10.tar.gz && \
  cp rebol-core/rebol /usr/local/bin/rebol && \
  chmod +x /usr/local/bin/rebol && \
  rm -rf /tmp/rebol-core /tmp/rebol-core-278-4-10.tar.gz

RUN curl -L -O https://github.com/red/red/archive/refs/heads/master.tar.gz && \
  tar -xzf master.tar.gz && \
  cd red-master && \
  echo 'Rebol[] do/args %red.r "-d -r --no-view %environment/console/CLI/console.red"' | rebol +q -s && \
  cp console /usr/local/bin/red && \
  chmod +x /usr/local/bin/red && \
  rm -rf /tmp/red-master /tmp/master.tar.gz

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
