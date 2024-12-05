#!/bin/bash

# Source the variables file
source ./../src/load_globals_unix.sh "./../src/global_vars.ini"
# Use the variables
grep "=" "./../src/global_vars.ini" | cut -d= -f1 |
while read var; do
  echo "env: $var = ${!var}"
done