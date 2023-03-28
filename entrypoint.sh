#!/bin/bash
set -eux

# start avahi
/usr/sbin/avahi-daemon --daemonize

# start cups
/usr/sbin/cupsd -f
