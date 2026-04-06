# Changelog

## [0.2.0] - 2026-04-06

### Fixed
- Fixed "Permission denied" error by changing `init: true` to `init: false` in config.yaml

## [0.1.0] - 2026-03-28

### Added
- Initial release
- Web-based terminal via ttyd with Home Assistant Ingress
- Mistral Vibe CLI integration with configurable model selection
- Home Assistant MCP integration via hass-mcp (entity control, service calls)
- Session persistence via tmux
- Configurable terminal theme (dark/light) and font size
- Auto-approve mode for hands-free operation
- Auto-update option for Mistral Vibe CLI
- Persistent configuration storage in /homeassistant/.mistral-vibe
- Home Assistant CLI (`ha` command) included
- Bash aliases for quick access (v, vc, ha-config, ha-logs)
- Support for amd64 and aarch64 architectures
