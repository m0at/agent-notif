#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== agent-notif installer ==="
echo ""

# Create install dir
mkdir -p "$INSTALL_DIR"

# Copy main script
cp "$SCRIPT_DIR/agent-notif" "$INSTALL_DIR/agent-notif"
chmod +x "$INSTALL_DIR/agent-notif"

# Create 'notif' alias (shorthand that defaults to send)
cat > "$INSTALL_DIR/notif" <<'NOTIF'
#!/usr/bin/env bash
exec agent-notif send "$@"
NOTIF
chmod +x "$INSTALL_DIR/notif"

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo "Add to your shell profile:"
  echo ""
  echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
  echo ""

  # Try to detect shell and suggest specific file
  case "${SHELL:-}" in
    */zsh)  echo "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.zshrc" ;;
    */bash) echo "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.bashrc" ;;
  esac
  echo ""
fi

echo "Installed:"
echo "  $INSTALL_DIR/agent-notif  (main CLI)"
echo "  $INSTALL_DIR/notif        (send shorthand)"
echo ""
echo "Next: agent-notif setup"
