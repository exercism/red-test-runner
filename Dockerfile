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
# echo "Red [] print 'hello" > /home/user/a.red
# docker build -t "red-test-runner:Dockerfile" .
# docker run --mount type=bind,src="/home/user/a.red",dst=/a.red red-test-runner:Dockerfile /bin/red /a.red
