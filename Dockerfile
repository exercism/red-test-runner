FROM ubuntu

COPY bin/console-headless /bin/red
# COPY bin/console-view_a4854f7c /bin/red
RUN chmod +x /bin/red

# from http://www.red-lang.org/p/download.html
## get dependencies, following red insruction (are all needed?)
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
      libc6:i386 \
      libcurl4:i386 \
       libgdk-pixbuf2.0-0:i386 \
#      libgtk-3-0:i386 \
#      libcanberra-gtk3-module:i386 \
#      wget \
      && \
#    wget http://static.red-lang.org/dl/auto/linux/red-latest -O /bin/red && \
#    chmod +x /bin/red && \
#    echo "q" | /bin/red
    echo "done."

# CMD [ "/bin/red" ]


# WORKDIR /opt/test-runner
# COPY . .
# ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
