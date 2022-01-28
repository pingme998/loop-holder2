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
RUN apt install apt-transport-https curl -y
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list
RUN apt update
RUN apt install brave-browser -y
RUN apt update
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
