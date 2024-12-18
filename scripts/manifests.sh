#!/usr/bin/env bash

# Copyright 2024 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
REGISTRY="ghcr.io/ru-asdx/fluxcd-charts"

info() {
    echo '[INFO] ' "$@"
}

info "Generating README files"
helm-docs --chart-search-root=${REPOSITORY_ROOT}/charts --template-files=helmdocs.gotmpl

for pkg in ${REPOSITORY_ROOT}/charts/*; do
  if [ -z "${pkg:-}" ]; then
    break
  fi
  info "Generating JSON schema for ${pkg}"
  helm schema -input ${pkg}/values.yaml -output ${pkg}/values.schema.json -draft 2019
done
