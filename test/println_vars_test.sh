#!/bin/bash

# Source the variables file
source ./../src/load_environment_as_var.sh "./../src/environment.ini"
# Use the variables
grep "=" "./../src/environment.ini" | cut -d= -f1 |
while read var; do
  echo "env: $var = ${!var}"
done