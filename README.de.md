# Mistral Vibe fuer Home Assistant

> **EXPERIMENTELL** - Dieses Add-on befindet sich in einer fruehen Entwicklungsphase. Erwarten Sie Breaking Changes, Bugs und unvollstaendige Funktionen. Nutzung auf eigene Gefahr.

Ein Home Assistant Add-on, das [Mistral Vibe](https://github.com/mistralai/mistral-vibe) (Mistral AIs CLI-Coding-Assistent) in Ihrer Home Assistant Instanz mit Web-Terminal und vollstaendiger Smart-Home-Integration via MCP ausfuehrt.

## Funktionen

- Web-basiertes Terminal ueber die HA-Seitenleiste (Ingress)
- Voller Lese-/Schreibzugriff auf Home Assistant Konfigurationsdateien
- Home Assistant MCP-Integration via hass-mcp (Entity-Steuerung, Service-Aufrufe, Automationen)
- Session-Persistenz via tmux
- Konfigurierbares Terminal (Dark/Light-Theme, Schriftgroesse)
- Auto-Approve-Modus fuer automatische Ausfuehrung
- Automatische Updates beim Start

## Installation

1. Dieses Repository in Home Assistant hinzufuegen:
   **Einstellungen > Add-ons > Add-on Store > ... (oben rechts) > Repositories**
   ```
   https://github.com/dktzde/ha_mistral_vibe
   ```
2. Das **Mistral Vibe** Add-on installieren
3. Mistral API-Key in der Add-on-Konfiguration eintragen (erhalten Sie einen unter https://console.mistral.ai)
4. Add-on starten und Web-UI ueber die Seitenleiste oeffnen

## Konfiguration

| Option | Standard | Beschreibung |
|--------|----------|--------------|
| `api_key` | *(erforderlich)* | Ihr Mistral API-Key |
| `model` | `default` | Modell: default (devstral-2), devstral-small, mistral-large, codestral |
| `auto_approve` | `false` | Alle Tool-Ausfuehrungen automatisch genehmigen |
| `enable_mcp` | `true` | Home Assistant MCP-Integration aktivieren |
| `terminal_font_size` | `14` | Schriftgroesse (10-24) |
| `terminal_theme` | `dark` | Terminal-Farbschema (dark/light) |
| `session_persistence` | `true` | tmux Session-Persistenz aktivieren |
| `auto_update_vibe` | `true` | Mistral Vibe automatisch beim Start aktualisieren |

## Dateipfade

| Pfad | Beschreibung | Zugriff |
|------|--------------|---------|
| `/homeassistant` | HA-Konfigurationsverzeichnis | Lesen/Schreiben |
| `/share` | Geteilter Ordner | Lesen/Schreiben |
| `/media` | Mediendateien | Lesen/Schreiben |
| `/ssl` | SSL-Zertifikate | Nur Lesen |
| `/backup` | Backups | Nur Lesen |

## Schnellbefehle

```bash
v              # Mistral Vibe starten
vc             # Letzte Session fortsetzen
ha-config      # Zum HA-Konfigurationsverzeichnis wechseln
ha-logs        # HA-Logs anzeigen
```

## Session-Persistenz (tmux)

Bei aktivierter Session-Persistenz (Standard) ueberlebt die Terminal-Session Browser-Aktualisierungen.

- Scrollen: Mausrad oder `Ctrl+B [` dann Pfeiltasten
- Trennen: `Ctrl+B d`
- Neues Fenster: `Ctrl+B c`

## Voraussetzungen

- Home Assistant OS oder Supervised Installation
- Mistral AI Konto mit API-Key (https://console.mistral.ai)
- amd64 oder aarch64 Architektur

## Lizenz

MIT
