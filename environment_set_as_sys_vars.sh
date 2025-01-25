#!/bin/bash

# Load the resolved var via this script
source environment_load_as_vars.sh

# Grab the env section and set capitalized keys with path values
sed -n '/#### ENV/ ,/####/{/####/!p}' "./environment.ini" | cut -d= -f1 |
while read var; do
  var_upper="$(echo "$var" | sed 's/.*/\U&/')"
  value="${!var}"
  echo "Setting environment variable: $var_upper=$value"
  setx "$var_upper" "$value"
  mkdir -p "$value"
done
