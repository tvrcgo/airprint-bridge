#!/sbin/init

systemctl start cups
systemctl enable cups

/usr/sbin/avahi-daemon --daemonize

/usr/sbin/cupsd -f
