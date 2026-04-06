#!/bin/bash
set -e

echo "[INFO] Starting Mistral Vibe for Home Assistant..."

# =============================================================================
# 1. Read configuration from Home Assistant
# =============================================================================
OPTIONS_FILE="/data/options.json"

API_KEY=$(jq -r '.api_key // ""' "$OPTIONS_FILE")
MODEL=$(jq -r '.model // "default"' "$OPTIONS_FILE")
AUTO_APPROVE=$(jq -r '.auto_approve // false' "$OPTIONS_FILE")
ENABLE_MCP=$(jq -r '.enable_mcp // true' "$OPTIONS_FILE")
FONT_SIZE=$(jq -r '.terminal_font_size // 14' "$OPTIONS_FILE")
THEME=$(jq -r '.terminal_theme // "dark"' "$OPTIONS_FILE")
SESSION_PERSIST=$(jq -r '.session_persistence // true' "$OPTIONS_FILE")
AUTO_UPDATE=$(jq -r '.auto_update_vibe // true' "$OPTIONS_FILE")
WORKING_DIR=$(jq -r '.working_directory // "/homeassistant"' "$OPTIONS_FILE")

# =============================================================================
# 2. Validate API key
# =============================================================================
if [ -z "$API_KEY" ]; then
    echo "[ERROR] Mistral API key is required. Set it in the add-on configuration."
    echo "[INFO] Get your API key at https://console.mistral.ai"
    # Keep container running so user can see the error in logs
    sleep infinity
fi

# =============================================================================
# 3. Set up persistent storage
# =============================================================================
PERSIST_DIR="/homeassistant/.mistral-vibe"
mkdir -p "$PERSIST_DIR"

# Symlink ~/.vibe to persistent directory
if [ ! -L /root/.vibe ]; then
    rm -rf /root/.vibe
    ln -s "$PERSIST_DIR" /root/.vibe
fi

echo "[INFO] Persistent storage: $PERSIST_DIR"

# =============================================================================
# 4. Write runtime environment file (sourced by .bashrc)
# =============================================================================
cat > /etc/profile.d/vibe-env.sh << ENVEOF
export MISTRAL_API_KEY="$API_KEY"
export HA_TOKEN="$SUPERVISOR_TOKEN"
export HA_URL="http://supervisor/core"
ENVEOF

# Also export for the current process (inherited by ttyd -> tmux -> bash)
export MISTRAL_API_KEY="$API_KEY"
export HA_TOKEN="$SUPERVISOR_TOKEN"
export HA_URL="http://supervisor/core"

# =============================================================================
# 5. Auto-update Mistral Vibe (if enabled)
# =============================================================================
if [ "$AUTO_UPDATE" = "true" ]; then
    echo "[INFO] Checking for Mistral Vibe updates..."
    pip3 install --no-cache-dir --break-system-packages --upgrade mistral-vibe 2>/dev/null \
        && echo "[INFO] Mistral Vibe updated successfully" \
        || echo "[WARN] Update check failed, continuing with installed version"
fi

# =============================================================================
# 6. Write Mistral Vibe config.toml
# =============================================================================
CONFIG_FILE="$PERSIST_DIR/config.toml"

cat > "$CONFIG_FILE" << 'TOMLEOF'
# Mistral Vibe Configuration (managed by HA add-on)
# Manual edits will be overwritten on add-on restart.
enable_telemetry = false
enable_auto_update = false
TOMLEOF

# Auto-approve mode: set in config.toml (no CLI flag exists)
if [ "$AUTO_APPROVE" = "true" ]; then
    echo 'auto_approve = true' >> "$CONFIG_FILE"
    echo "[INFO] Auto-approve mode enabled"
fi

# Set model if not default (devstral-2 is Vibe's built-in default)
if [ "$MODEL" != "default" ]; then
    case "$MODEL" in
        devstral-small)
            echo 'active_model = "devstral-small"' >> "$CONFIG_FILE"
            ;;
        mistral-large)
            # Define custom model alias for mistral-large
            printf '\n[[models]]\nalias = "mistral-large"\nprovider = "mistral"\nmodel = "mistral-large-latest"\n' >> "$CONFIG_FILE"
            echo 'active_model = "mistral-large"' >> "$CONFIG_FILE"
            ;;
        codestral)
            # Define custom model alias for codestral
            printf '\n[[models]]\nalias = "codestral"\nprovider = "mistral"\nmodel = "codestral-latest"\n' >> "$CONFIG_FILE"
            echo 'active_model = "codestral"' >> "$CONFIG_FILE"
            ;;
    esac
    echo "[INFO] Model set to: $MODEL"
else
    echo "[INFO] Using default model (devstral-2)"
fi

# Configure MCP server for Home Assistant integration
if [ "$ENABLE_MCP" = "true" ]; then
    cat >> "$CONFIG_FILE" << MCPEOF

[[mcp_servers]]
name = "homeassistant"
transport = "stdio"
command = "hass-mcp"
args = []
env = { "HA_URL" = "http://supervisor/core", "HA_TOKEN" = "$SUPERVISOR_TOKEN" }
MCPEOF
    echo "[INFO] MCP configured with Home Assistant integration"
else
    echo "[INFO] MCP disabled"
fi

# =============================================================================
# 7. Configure terminal theme
# =============================================================================
if [ "$THEME" = "dark" ]; then
    COLORS="background=#1e1e2e,foreground=#cdd6f4,cursor=#f5e0dc"
else
    COLORS="background=#eff1f5,foreground=#4c4f69,cursor=#dc8a78"
fi

# =============================================================================
# 8. Configure session persistence
# =============================================================================
if [ "$SESSION_PERSIST" = "true" ]; then
    SHELL_CMD="tmux new-session -A -s vibe"
    echo "[INFO] Session persistence enabled (tmux)"
else
    SHELL_CMD="bash --login"
fi

# =============================================================================
# 9. Launch web terminal
# =============================================================================
echo "[INFO] Starting web terminal on port 7681..."

cd "$WORKING_DIR"

exec ttyd --port 7681 --writable --ping-interval 30 --max-clients 5 \
    -t "fontSize=$FONT_SIZE" \
    -t "fontFamily=Monaco,Consolas,monospace" \
    -t "scrollback=20000" \
    -t "theme=$COLORS" \
    $SHELL_CMD
