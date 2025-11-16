#!/usr/bin/env bash
set -euo pipefail

# Resolve paths
ROOT_DIR="$( cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"
HL_UPDATE="$ROOT_DIR/Codebase/Dependencies/HL-Setup/setup.sh"

# Check if the dependency exists
if [[ ! -x "$HL_UPDATE" ]]; then
    echo "[ERROR] HL-Setup script not found or not executable:"
    echo "  $HL_UPDATE"
    exit 1
fi

# Forward all arguments to HL-Update's update.sh
exec "$HL_UPDATE" "$@"
