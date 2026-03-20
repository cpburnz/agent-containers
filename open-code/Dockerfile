# Build stage
FROM agent-base AS builder

# 1. Install global modules
RUN npm install -g opencode-ai && \
  npm install -g @anthropic-ai/claude-code && \
  echo "Installed Open Code version: $(opencode --version)"

# 2. Clone and install the Claude Max Proxy
WORKDIR /home/node
RUN git clone https://github.com/rynfar/opencode-claude-max-proxy.git && \
  cd opencode-claude-max-proxy && \
  bun install


# Runtime stage
FROM agent-base

# Copy the installed global modules from builder
COPY --from=builder --chown=node:node /home/node/.npm-global /home/node/.npm-global

# Copy the proxy app from builder
COPY --from=builder --chown=node:node /home/node/opencode-claude-max-proxy /home/node/opencode-claude-max-proxy

# Copy and configure the entrypoint script
COPY --chown=node:node entrypoint.sh /home/node/entrypoint.sh
RUN chmod +x /home/node/entrypoint.sh

# Display version information
RUN echo "" && \
  echo "\e[34m=================================================================\e[0m" && \
  echo "\e[34m                   OPEN CODE VERSION                           \e[0m" && \
  echo "\e[34m=================================================================\e[0m" && \
  echo "\e[34m" && opencode --version && \
  echo "\e[0m" && \
  echo ""

# Route container startup through our script
ENTRYPOINT ["/home/node/entrypoint.sh"]
CMD ["opencode"]
