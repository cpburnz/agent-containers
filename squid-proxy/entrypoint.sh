#!/bin/sh
set -e

# Remove stale PID file.
rm -f /run/squid/squid.pid

# Run squid.
exec squid -f /etc/squid/squid.conf --foreground -sYC
