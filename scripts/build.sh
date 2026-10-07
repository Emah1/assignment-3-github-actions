#!/usr/bin/env bash

set -u

IMAGE="devops-ci-app:build"

echo "======================================"
echo "        DOCKER BUILD CHECK"
echo "======================================"

echo "Building Docker image: $IMAGE"

if docker build -t "$IMAGE" .; then
    echo
    echo "BUILD SUCCESSFUL"
    exit 0
else
    echo
    echo "BUILD FAILED"
    exit 1
fi
