#
# This Dockerfile creates the debug agent image which can run a shell for
# debugging.
#
FROM debian:forky-slim

# Install runtime-time packages.
RUN apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates curl iproute2 && \
	rm -rf /var/lib/apt/lists/*

CMD ["sh"]
