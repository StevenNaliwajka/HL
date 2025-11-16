# HomeLab(HL)

*A modular infrastructure framework for scalable, composable system orchestration.*

----

setup.exe can be compiled by ./hl/ exe compiler when i find it.


## HL as a Central Orchestrator

### HL serves as the parent coordinator for all modules across machines.

While each major subsystem (Web, Edge, Deploy, etc.) runs on its own dedicated hardware, HL is responsible for managing the overall state, configuration, and communication between them.

HL performs the following high-level functions:
- Loads each submodule’s configuration (setup_manifest.json)
- Remotely connects to each system node (via SSH, agent, or API)
- Recursively installs dependencies and submodules on the target machine
- Runs validation and tests remotely to ensure correct state
- Triggers Docker builds (remotely or locally as needed)
- Handles orchestration and rollout in a top-down, role-aware structure

This design allows HL to centrally manage multiple distributed nodes, while each module retains independence and self-sufficiency.

---

## Project Categories

The HL ecosystem is composed of module repositories grouped by category:

### Web [DoneSomethingSimilar](https://github.com/StevenNaliwajka/KSU-AnalysisNode)

* `Plotter`
* `Uploader`
* `Downloader`
* `Status`

### Edge 

* `NginxManager` [Finished but not parced](https://github.com/StevenNaliwajka/HL-EdgeGate)
* `Certbot` [Finished but not parced](https://github.com/StevenNaliwajka/HL-EdgeGate)
* `DynamicDNS` [Finished but not parced](https://github.com/StevenNaliwajka/DynamicDNSManager)

### Deploy

* `PFsense` [in prog](https://github.com/StevenNaliwajka/pfSenseManager)
* `NAS`
* `Proxmox`

### Sensor

* `GWS5000` [Finished but not parced](https://github.com/StevenNaliwajka/KSU-OfficeNode)
* `Moisture` [Finished but not parced](https://github.com/StevenNaliwajka/KSU-TowerNode)
* `Atmosphere`

### Common

* `Setup` [HL-Common-Setup](https://github.com/StevenNaliwajka/HL-Common-Setup)
* `Health`
* `Auth`
* `DataLoader` [DoneSomethingSimilar](https://github.com/StevenNaliwajka/KSU-AnalysisNode)

### Runtime

* `DockerBuilder`
* `ProcessManager`
* `Scheduler`

### Manager

* `LoadBalancer`

Each of the above modules is stored in its own repository and adheres to a common interface and structure.

---

## HL Responsibilities

As the root of the ecosystem, HL is responsible for:

* Discovering available modules
* Parsing each module’s `setup_manifest.json`
* Recursively setting up dependent modules
* Passing configuration and shared state down the stack
* Managing Docker builds, hooks, and service orchestration
* Running testing pipelines (lint, unit, integration)
* Handling remote or local resolution of dependencies

---

## Setup Lifecycle

Each module is configured using a standard lifecycle process, initiated by HL:

```
Parse setup_manifest.json  
Run pre_setup hook  
Install OS / pip / Git dependencies  
Prompt for and install declared dependents (recursively)  
Prompt user for configuration (if configurable)  
Run post_setup hook  
Build Docker image (if docker.build = true)  
On launch:  
  Run on_launch hooks  
  Optionally run healthcheck  
Setup complete
```

---

## Key Features

* **Composable Design**: Mix and match modules across domains (Edge, Web, Sensor, etc.)
* **Recursive Setup**: Parent modules configure and install all dependent children
* **Config-Driven**: Everything starts from a single `setup_manifest.json` file per module
* **Portable & Automatable**: Works in CI/CD, local dev, or hybrid environments
* **Modular Testing**: Per-module linting, unit tests, and integration hooks
* **Docker-Aware**: Optional Docker builds per module with tagging and reuse
* **Remote-Aware**: Supports both local path resolution and Git-based remote pulls
* **Status Tracking**: Built-in `.setup_status.json` for idempotent deployments

---

## Environment Variables

These can be passed to customize HL behavior during setup:

| Variable             | Description                                       |
| -------------------- | ------------------------------------------------- |
| `PARENT_MODULE_PATH` | Overrides the path for dependent module discovery |
| `NO_INTERACTIVE`     | Runs all setup logic without prompts              |
| `FORCE_SETUP`        | Ignores `.setup_status.json` and forces re-setup  |
| `CONFIG_PATH`        | Override path for config file                     |
| `API_KEY`, `DB_URL`  | Inject secrets or runtime values                  |

---

## Example Manifest

```jsonc
{
  "module": "HL",
  "category": "HL",
  "dependencies": {
    "os": ["curl", "python3"],
    "pip": ["requests", "dash"],
    "git": ["https://github.com/example/utility-lib"],
    "docker": false
  },
  "dependents": {
    "Plotter": {
      "repo": "https://github.com/example/plotter",
      "default": true
    },
    "Uploader": {
      "repo": "https://github.com/example/uploader",
      "default": true
    }
  },
  "docker": {
    "build": true,
    "entrypoint": "main.py",
    "expose_port": 8050
  },
  "configurable": true,
  "hooks": {
    "pre_setup": "scripts/pre_setup.sh",
    "post_setup": "scripts/post_setup.sh",
    "on_launch": ["scripts/init.sh"],
    "healthcheck": "scripts/health_check.sh"
  }
}
```

---

## Contributing

Each module is stored in its own repository. Contributions can be made to any module,
but they must conform to the manifest structure and hook interface defined by HL.
