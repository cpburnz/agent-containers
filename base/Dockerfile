#
# Build stage.
#
FROM dhi.io/node:24-dev as build

# Install build-time packages.
RUN apt-get update && \
	apt-get install -y --no-install-recommends xz-utils && \
	rm -rf /var/lib/apt/lists/*

# Setup directories.
RUN mkdir -p /build && \
	mkdir -p /empty && touch /empty/.stub

# Download curl.
WORKDIR /build/curl
ADD 'https://github.com/stunnel/static-curl/releases/download/8.19.0/curl-linux-x86_64-glibc-8.19.0.tar.xz' ./
RUN tar -xJf curl-linux-x86_64-glibc-8.19.0.tar.xz && \
	echo '6f7947edef5dc66fab1de22e4c41fa4dfac70edf94044b09ce62132582b6e048  curl' | sha256sum -c

#
# Runtime stage.
#
FROM dhi.io/node:24

# Copy curl.
COPY --from=build --chmod=755 /build/curl/curl /usr/bin/curl

# Setup app directory.
COPY --from=build --chown=node /empty /app

# Setup node user directories.
COPY --from=build --chown=node /empty /home/node/.config
COPY --from=build --chown=node /empty /home/node/.local
