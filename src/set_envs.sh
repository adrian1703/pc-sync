#!/bin/bash

# Source the variables file
source ./load_globals_unix.sh

# Grab the env section and set capitalized keys with path values
sed -n '/#### ENV/ ,/####/{/####/!p}' "./global_vars.ini" | cut -d= -f1 |
while read var; do
  var_upper="$(echo "$var" | sed 's/.*/\U&/')"
  value="${!var}"
  echo "Setting environment variable: $var_upper=$value"
  setx "$var" "$value"
done
