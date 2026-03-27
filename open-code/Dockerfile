# Build stage
FROM agent-base AS builder

# 1. Install global modules
RUN bun install -g opencode-ai && \
	echo "Installed Open Code version: $(opencode --version)"

# Runtime stage
FROM agent-base

# Copy the installed global modules from builder
COPY --from=builder --chown=node:node /home/node/.npm-global /home/node/.npm-global

# Copy and configure the entrypoint script
COPY --chown=node:node --chmod=755 entrypoint.sh /home/node/entrypoint.sh

# Display version information
RUN echo "" && \
	echo "\e[34m=================================================================\e[0m" && \
	echo "\e[34m                        OPEN CODE VERSION                        \e[0m" && \
	echo "\e[34m=================================================================\e[0m" && \
	echo "\e[34m" && opencode --version && \
	echo "\e[0m" && \
	echo ""

# Route container startup through our script
ENTRYPOINT ["/home/node/entrypoint.sh"]
CMD ["opencode"]
