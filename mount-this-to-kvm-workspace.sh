#!/bin/bash

# TODO: Make this generic.

DEST="${HOME}/kvm-workspace/software/git/kvm-gpu-guide"

echo ""
echo "sudo mount --bind ./ ${DEST}"
echo ""

sudo mount --bind ./ "${DEST}"

