#
# This Dockerfile creates the Squid proxy image which is used to proxy and
# restrict network access for agent containers.
#
FROM debian:forky-slim

# Install runtime-time packages.
RUN apt-get update && \
	apt-get install -y --no-install-recommends squid-openssl && \
	rm -rf /var/lib/apt/lists/*

# Setup squid.
COPY --chmod=755 entrypoint.sh /entrypoint.sh

# Configure squid.
RUN rm -rf /etc/squid/*
COPY access.conf /etc/squid/access.conf
COPY ports.conf /etc/squid/ports.conf
COPY squid.conf /etc/squid/squid.conf

# Run squid.
USER proxy
EXPOSE 3128
WORKDIR /run/squid
CMD ["/entrypoint.sh"]
