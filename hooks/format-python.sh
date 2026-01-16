#!/bin/bash
# Auto-format Python files after Edit/Write

set -euo pipefail

read -r file_path

if [[ -f "$file_path" && "$file_path" == *.py ]]; then
    ruff format "$file_path" 2>/dev/null && \
    ruff check --fix "$file_path" 2>/dev/null || true
fi
