#!/usr/bin/env bash
set -euo pipefail

echo "Generate CDI"
sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
nvidia-ctk cdi list
# fedora conf
if [[ "$(getenforce)" == "Enforce" ]]; then
  echo "Allow gpu on containers (fedora)"
  sudo setsebool -P container_use_devices true
fi
# test
echo "Test"
sudo podman run --rm --device nvidia.com/gpu=all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
