FROM ubuntu:kinetic-20220801

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
  unzip \
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

RUN curl -L -O https://github.com/red/red/archive/d99a1018a57b5179cfe57debeab72b958a716de5.zip && \
  unzip d99a1018a57b5179cfe57debeab72b958a716de5.zip && \
  cd red-d99a1018a57b5179cfe57debeab72b958a716de5 && \
  echo 'Rebol[] do/args %red.r "-d -r --no-view %environment/console/CLI/console.red"' | rebol +q -s && \
  cp console /usr/local/bin/red && \
  chmod +x /usr/local/bin/red && \
  rm -rf /tmp/red-d99a1018a57b5179cfe57debeab72b958a716de5 /tmp/d99a1018a57b5179cfe57debeab72b958a716de5.zip

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
