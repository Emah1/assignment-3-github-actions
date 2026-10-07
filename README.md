# Assignment 3 — GitHub Actions CI/CD

## Overview

This project demonstrates a local DevOps CI/CD workflow using Bash, Docker, Docker Compose, and GitHub Actions.

The project provides a diagnostic CLI that can display system information and check TCP connectivity to a specified host and port.

## Project Structure

```text
assignment-3-github-actions/
├── README.md
├── app/
│   └── app.sh
├── scripts/
│   ├── lint.sh
│   └── build.sh
├── tests/
│   └── test.sh
├── Dockerfile
├── compose.yaml
├── .dockerignore
└── .github/
    └── workflows/
        └── ci.yml
