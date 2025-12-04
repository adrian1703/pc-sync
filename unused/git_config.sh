#!/bin/bash

repo_dir="$DEV/projects/ReinstallPc/Git/etc/"
git_dir="$DEV/utils/Git/etc/"
files=$(find "$repo_dir" -type f | sed -E 's|.*/etc/||')

print_files() {
  echo "The following files are concerned:"
  echo "$files"
}

copy() {
    local src=$1
    local dst=$2

    for file in $files; do
        cp -f "$src$file" "$dst$file"
    done
}

# Define subroutine for pushing changes
push_changes() {
  echo "Pushing changes to config project"
  copy "$git_dir" "$repo_dir"
}

# Define subroutine for pulling changes
pull_changes() {
  echo "Pulling changes to local config"
  copy "$repo_dir" "$git_dir"
}

# Main script logic
if [ "$1" = "-push" ]; then
  print_files
  push_changes
elif [ "$1" = "-pull" ]; then
  print_files
  pull_changes
else
  echo "Unknown option, please use -push or -pull"
fi
