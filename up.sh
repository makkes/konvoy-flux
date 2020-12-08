#!/usr/bin/env bash

set -euo pipefail

ENV=${1:-stable}
KUSTOMIZATION="${ENV}-kustomization.yaml"
[ -f ${KUSTOMIZATION} ] || (echo "unknown environment '${ENV}'" && exit 1)

kind create cluster --config=kind-config.yaml

function seed_images() {
    for image in $(cat images.txt) ; do
        docker pull ${image}
        kind load docker-image ${image}
    done
}

seed_images

flux install

kubectl apply -f source.yaml -f "${KUSTOMIZATION}"
