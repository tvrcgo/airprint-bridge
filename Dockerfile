
FROM ubuntu:18.04

COPY drivers/ /root/drivers/
COPY config/cupsd.conf /etc/cups/cupsd.conf
# COPY services/*.service /etc/avahi/services/
COPY entrypoint.sh /entrypoint.sh

RUN set -eux; \
    sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      cups \
      lsb \
      avahi-daemon \
      avahi-discover \
    ; \
    # install printer driver
    dpkg -i /root/drivers/EPSON_L3250/*arm64.deb; \
    rm -rf /root/drivers; \
    # clean
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

CMD [ "sh", "/entrypoint.sh" ]
