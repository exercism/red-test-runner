FROM ubuntu

COPY bin/console-headless /bin/red
RUN chmod +x /bin/red

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
      libc6:i386 \
      libcurl4:i386 \
      libgdk-pixbuf2.0-0:i386

# Red can be run in Docker only in script mode (no REPL or stdin):
# docker build -t "red-test-runner:Dockerfile" .
# docker run --mount type=bind,src="/home/user/exercism/red-test-runner",dst=/opt/test-runner red-test-runner:Dockerfile /bin/red /opt/test-runner/test-runner-test.red
