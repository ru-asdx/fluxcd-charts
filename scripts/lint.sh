#!/usr/bin/env bash

# Copyright 2024 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
REGISTRY="ghcr.io/ru-asdx/fluxcd-charts"

info() {
    echo '[INFO] ' "$@"
}

info "Running helm lint for all charts"
helm lint ${REPOSITORY_ROOT}/charts/*

for pkg in ${REPOSITORY_ROOT}/charts/*; do
  if [ -z "${pkg:-}" ]; then
    break
  fi
  chartName=${pkg##*/}
  info "Running helm template and kubeconform for ${chartName}"
  helm template ${chartName} --include-crds ${pkg} | kubeconform -strict -ignore-missing-schemas -verbose
done
