#!/bin/bash

if [ "$1" = "-push" ]; then
  echo "Pushing changes to config project"

elif [ "$1" = "-pull" ]; then
  echo "Pulling changes to local config"

else
  echo "Unknown option, please use -push or -pull"
fi