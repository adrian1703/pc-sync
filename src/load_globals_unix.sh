#!/bin/bash

# Function to read lines containing "=" from the file
read_lines() {
  grep "=" "$1"
}

sanitize_dir_separators() {
  sed -E "s/\|/\//g"
}

# Function to process lines and resolve key-value pairs into an associative array
process_kv_pairs() {
  declare -A vars
  while IFS= read -r line; do
    # Extract key and value
    key=$(echo "$line" | cut -d= -f1)
    value=$(echo "$line" | cut -d= -f2-)

    # Resolve placeholders in the value using existing vars
    for k in "${!vars[@]}"; do
      value=${value//\$${k}\$/${vars[$k]}}
    done

    # Store resolved value in the associative array
    vars[$key]=$value
  done

  # Return the associative array (print it as a formatted string)
  for k in "${!vars[@]}"; do
    echo "$k=${vars[$k]}"
  done
}

## Function to export variables from a formatted key-value input
#export_kv_pairs() {
#  while IFS= read -r line; do
#    key=$(echo "$line" | cut -d= -f1)
#    value=$(echo "$line" | cut -d= -f2-)
#    echo "export $key=\"$value\""
#  done
#}

# Function to export variables from a formatted key-value input
export_kv_pairs() {
  while IFS= read -r line; do
    echo "export $line"
  done
}

# Main function
main() {
  # Allow overriding the global_vars file via a command-line argument or environment variable
  dir="$(echo "$0" | sed -E 's#/[^/]*$##' )"
  vars_file="${1:-"$dir/global_vars.ini"}"
  # Ensure the file exists
  if [[ ! -f "$vars_file" ]]; then
    echo "Error: Configuration file '$vars_file' not found."
    exit 1
  else
    echo "Loading values from: $vars_file"
  fi

  # Process key-value pairs and store them in an intermediate format
  kv_pairs=$(read_lines "$vars_file" | sanitize_dir_separators | process_kv_pairs)
  # Export the processed key-value pairs
  eval "$(echo "$kv_pairs" | export_kv_pairs)"
  echo "Test Var 'dev'=$dev"
}

main "$1"