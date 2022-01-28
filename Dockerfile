FROM debian:stretch

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      bash \
      fluxbox \
      unzip \
      git \
      net-tools \
      novnc \
      socat \
      supervisor \
      x11vnc \
      xterm \
      xvfb

# Setup demo environment variables
COPY novnc.zip /novnc.zip
RUN unzip -o /novnc.zip -d /usr/share
RUN rm /novnc.zip
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes
COPY . /app
RUN chmod +x /app/conf.d/websockify.sh
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]
