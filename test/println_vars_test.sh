#!/bin/bash

# Source the variables file
source environment_load_as_vars.sh "./../environment.ini"
# Use the variables
grep "=" "./../environment.ini" | cut -d= -f1 |
while read var; do
  echo "env: $var = ${!var}"
done