#!/bin/bash

# Example of how to import environment as vars
# source environment_load_as_vars.sh

# Grab the env section and set capitalized keys with path values
sed -n '/#### ENV/ ,/####/{/####/!p}' "./environment.ini" | cut -d= -f1 |
while read var; do
  var_upper="$(echo "$var" | sed 's/.*/\U&/')"
  value="${!var}"
  echo "Setting environment variable: $var_upper=$value"
  setx "$var" "$value"
done
