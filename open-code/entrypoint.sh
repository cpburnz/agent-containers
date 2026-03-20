#!/usr/bin/env bash
set -e

echo "Starting Claude Max Proxy (Passthrough Mode)..."
ln -sf /home/node/.claude/claude.json /home/node/.claude.json
export CLAUDE_PROXY_PASSTHROUGH=1

# Start the proxy supervisor in the background
cd /home/node/opencode-claude-max-proxy
./bin/claude-proxy-supervisor.sh >/tmp/claude-proxy.log 2>&1 &

# Return to the app working directory
cd /app

# Wait up to 5 seconds for the proxy health endpoint to be responsive
for i in {1..20}; do
  if curl -s http://127.0.0.1:3456/health >/dev/null; then
    break
  fi
  sleep 0.25
done

# Route OpenCode traffic to the proxy
export ANTHROPIC_API_KEY="dummy"
export ANTHROPIC_BASE_URL="http://127.0.0.1:3456"

# Execute the main command (opencode, claude login, /bin/bash, etc.)
exec "$@"
