#
# Build stage.
#
FROM dhi.io/node:24-dev as build
USER node
WORKDIR /build

# Download opencode (latest version).
RUN npm install opencode-linux-x64 --ignore-scripts && \
	echo "Installed Open Code version: $(node_modules/opencode-linux-x64/bin/opencode --version)"

#
# Runtime stage.
#
FROM localhost/agent-base
USER node

# Copy opencode.
COPY --from=build --chmod=755 /build/node_modules/opencode-linux-x64/bin/opencode /usr/bin/opencode

# Run opencode.
WORKDIR /app
CMD ["opencode"]
