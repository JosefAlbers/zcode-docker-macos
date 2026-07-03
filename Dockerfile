FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    vim \
    curl \
    wget \
    python3 \
    xdg-utils \
    dbus-x11 \
    libnotify4 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0t64 \
    libxss1 \
    libasound2t64 \
    libsecret-1-0 \
    libuuid1 \
    libatspi2.0-0t64 \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://cdn-zcode.z.ai/zcode/electron/releases/3.2.4/ZCode-3.2.4-linux-arm64.deb -O /tmp/zcode.deb \
    && dpkg --install --force-depends /tmp/zcode.deb \
    && apt-get update \
    && apt-get install -f -y \
    && rm -rf /var/lib/apt/lists/* /tmp/zcode.deb

RUN cat << 'EOF' > /usr/local/bin/link-catcher
#!/usr/bin/env python3
import sys
url = sys.argv[-1] if len(sys.argv) > 1 else "No URL detected"
with open("/OAUTH_URL.txt", "w") as f:
    f.write(url + "\n")
print("\n" + "="*60, flush=True)
print("[link-catcher] URL captured:")
print(f"\n{url}\n")
print("="*60 + "\n", flush=True)
EOF
RUN chmod +x /usr/local/bin/link-catcher \
    && ln -sf /usr/local/bin/link-catcher /usr/bin/xdg-open \
    && ln -sf /usr/local/bin/link-catcher /usr/bin/x-www-browser \
    && ln -sf /usr/local/bin/link-catcher /usr/bin/gnome-open \
    && ln -sf /usr/local/bin/link-catcher /usr/bin/open

RUN cat << 'EOF' > /usr/local/bin/entrypoint.sh
#!/bin/bash
eval $(dbus-launch --sh-syntax)
export DBUS_SESSION_BUS_ADDRESS
echo "export DBUS_SESSION_BUS_ADDRESS='$DBUS_SESSION_BUS_ADDRESS'" > /root/.dbus-env
exec "$@"
EOF
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]
