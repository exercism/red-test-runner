FROM ubuntu:21.04 AS build

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y curl

RUN curl -L -o /usr/local/bin/red https://static.red-lang.org/dl/auto/linux/red-latest && \
  chmod +x /usr/local/bin/red

# RUN /usr/local/bin/red --no-console --no-view build libRed

# WORKDIR /opt/rebol

# RUN curl -L -O http://www.rebol.com/downloads/v278/rebol-core-278-4-10.tar.gz
# RUN tar -xzf rebol-core-278-4-10.tar.gz
# RUN chmod +x rebol-core/rebol
# RUN cp rebol-core/rebol /usr/local/bin/rebol

# WORKDIR /opt/red

# RUN curl -L -O https://github.com/red/red/archive/refs/tags/v0.6.4.tar.gz
# RUN tar -xzf v0.6.4.tar.gz
# RUN cd red-0.6.4
# RUN echo 'Rebol[] do/args %red.r "-d -r --no-view %environment/console/CLI/console.red"' | /usr/local/bin/rebol +q -s

FROM ubuntu:21.04 AS runtime

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
  libc6:i386 \
  libcurl4:i386 \
  libgdk-pixbuf2.0-0:i386

COPY --from=build /usr/local/bin/red /usr/local/bin/red

WORKDIR /opt/test-runner

# # Pre-compile binaries
RUN /usr/local/bin/red --no-console --no-view build libRed

# COPY bin/console-headless /usr/local/bin/red
# RUN chmod +x /usr/local/bin/red

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
