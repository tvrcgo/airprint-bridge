
FROM ubuntu:18.04

COPY drivers/ /root/drivers/

RUN set -eux; \
    sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      vim \
      sudo \
      whois \
      cups \
      cups-client \
      cups-filters \
      cups-bsd \
      cups-ipp-utils \
      avahi-daemon \
      avahi-discover \
      lsb \
      printer-driver-escpr \
    ; \
    # install official printer driver
    dpkg -i /root/drivers/**/*arm64.deb; \
    rm -rf /root/drivers; \
    # enable UDP broadcast
    echo "net.ipv4.icmp_echo_ignore_broadcasts=0" >> /etc/sysctl.conf; \
    echo "net.ipv4.conf.all.bc_forwarding=1" >> /etc/sysctl.conf; \
    # clean
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN useradd ${CUPS_USERNAME:-cups} \
      --password=$(mkpasswd ${CUPS_PASSWORD:-cups}) \
      --groups=sudo,lp,lpadmin \
      --no-create-home \
      --shell=/bin/bash \
    ; \
    sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

COPY cups/cupsd.conf /etc/cups/
COPY avahi/*.service /etc/avahi/services/
COPY avahi/*.conf /etc/avahi/
COPY avahi/*.sh /usr/bin/
COPY entrypoint.sh /entrypoint.sh

EXPOSE 631
EXPOSE 5353/udp

CMD [ "sh", "/entrypoint.sh" ]
