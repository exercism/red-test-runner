FROM ubuntu:24.04@sha256:534baea6a22c03a63003dbc8dbe78fe34bc0d7e595d9a9dc9834884ff530eb55

ENV REBOL_VERSION=278-4-10
ENV RED_VERSION=0.6.6

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
  curl \
  libc6:i386 \
  libcurl4:i386 \
  libgdk-pixbuf-2.0-0:i386 && \
  apt-get purge --auto-remove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN curl -L -O http://www.rebol.com/downloads/v${REBOL_VERSION%%-*}/rebol-core-${REBOL_VERSION}.tar.gz && \
  tar -xzf rebol-core-${REBOL_VERSION}.tar.gz && \
  cp rebol-core/rebol /usr/local/bin/rebol && \
  chmod +x /usr/local/bin/rebol && \
  rm -rf /tmp/rebol-core /tmp/rebol-core-${REBOL_VERSION}.tar.gz

RUN curl -L -O https://github.com/red/red/archive/refs/tags/v${RED_VERSION}.tar.gz && \
  tar -xzf v${RED_VERSION}.tar.gz && \
  cd red-${RED_VERSION} && \
  echo 'Rebol[] do/args %red.r "-d -r --no-view %environment/console/CLI/console.red"' | rebol +q -s && \
  cp console /usr/local/bin/red && \
  chmod +x /usr/local/bin/red && \
  rm -rf /tmp/red-${RED_VERSION} /tmp/v${RED_VERSION}.tar.gz

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
