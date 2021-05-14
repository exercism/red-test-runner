FROM ubuntu:21.04

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
  curl \
  libc6:i386 \
  libcurl4:i386 \
  libgtk-3-0:i386 \
  libgdk-pixbuf2.0-0:i386

WORKDIR /tmp

RUN curl -L -O http://www.rebol.com/downloads/v278/rebol-core-278-4-10.tar.gz
RUN tar -xzf rebol-core-278-4-10.tar.gz
RUN cp rebol-core/rebol /usr/local/bin/rebol
RUN chmod +x /usr/local/bin/rebol

WORKDIR /test
RUN curl -L -O https://github.com/red/red/archive/refs/heads/master.tar.gz
RUN tar -xzf master.tar.gz
WORKDIR /test/red-master
RUN echo 'Rebol[] do/args %red.r "-d -r --no-view %environment/console/CLI/console.red"' | rebol +q -s
RUN cp /test/red-master/console /usr/local/bin/red
RUN chmod +x /usr/local/bin/red

WORKDIR /opt/test-runner

# # Pre-compile binaries
# RUN /usr/local/bin/red --no-console --no-view build libRed

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
