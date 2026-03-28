# Mistral Vibe pour Home Assistant

> **EXPERIMENTAL** - Ce module complémentaire est en développement précoce. Attendez-vous à des changements majeurs, des bugs et des fonctionnalités incomplètes. Utilisez-le à vos propres risques.

Un module complémentaire Home Assistant qui exécute [Mistral Vibe](https://github.com/mistralai/mistral-vibe) (l'assistant de codage CLI de Mistral AI) dans votre instance Home Assistant avec un terminal web et une intégration complète de la maison connectée via MCP.

## Fonctionnalités

- Terminal web accessible depuis la barre latérale HA (Ingress)
- Accès complet en lecture/écriture aux fichiers de configuration Home Assistant
- Intégration MCP Home Assistant via hass-mcp (contrôle d'entités, appels de services, automatisations)
- Persistance de session via tmux
- Terminal configurable (thème sombre/clair, taille de police)
- Mode approbation automatique pour une utilisation sans intervention
- Mise à jour automatique au démarrage

## Installation

1. Ajoutez ce dépôt à Home Assistant :
   **Paramètres > Modules complémentaires > Boutique > ... (en haut à droite) > Dépôts**
   ```
   https://github.com/dktzde/ha_mistral_vibe
   ```
2. Installez le module **Mistral Vibe**
3. Configurez votre clé API Mistral (obtenez-en une sur https://console.mistral.ai)
4. Démarrez le module et ouvrez l'interface web depuis la barre latérale

## Configuration

| Option | Par défaut | Description |
|--------|------------|-------------|
| `api_key` | *(requis)* | Votre clé API Mistral |
| `model` | `default` | Modèle : default (devstral-2), devstral-small, mistral-large, codestral |
| `auto_approve` | `false` | Approuver automatiquement toutes les exécutions d'outils |
| `enable_mcp` | `true` | Activer l'intégration MCP Home Assistant |
| `terminal_font_size` | `14` | Taille de police (10-24) |
| `terminal_theme` | `dark` | Thème du terminal (dark/light) |
| `session_persistence` | `true` | Activer la persistance de session tmux |
| `auto_update_vibe` | `true` | Mise à jour automatique au démarrage |

## Emplacements des fichiers

| Chemin | Description | Accès |
|--------|-------------|-------|
| `/homeassistant` | Répertoire de configuration HA | lecture-écriture |
| `/share` | Dossier partagé | lecture-écriture |
| `/media` | Fichiers multimédias | lecture-écriture |
| `/ssl` | Certificats SSL | lecture seule |
| `/backup` | Sauvegardes | lecture seule |

## Commandes rapides

```bash
v              # Démarrer Mistral Vibe
vc             # Reprendre la dernière session
ha-config      # Aller au répertoire de configuration HA
ha-logs        # Voir les logs HA
```

## Prérequis

- Installation Home Assistant OS ou Supervised
- Compte Mistral AI avec clé API (https://console.mistral.ai)
- Architecture amd64 ou aarch64

## Licence

MIT
