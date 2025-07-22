#!/usr/bin/env bash
curl http://localhost:11434/api/pull \
  -H "Content-Type: application/json" \
  -d '{"name": "deepseek-coder-v2:latest"}'
