#!/bin/bash

installer="ideaIU-latest.exe"
dl_link="https://download.jetbrains.com/idea/ideaIU-latest.exe"
dl_folder="$TMP"
trgt_folder="$IDES/jetbrains/IntelliJ IDEA Ultimate" # this is somehow sometimes lowercase dont ask me why
silent_config="$SETUP_PROJ/src/intellij/silent.config"
log_file="$TMP/intellij_install.log"

echo "Installing Intellij ..."
echo "installer: $installer"
echo "download link: $dl_link"
echo "download folder: $dl_folder"
echo "target folder: $trgt_folder"

# Ensure target folder exists
mkdir -p "$dl_folder"

# Download the installer
curl -L $dl_link -o "$dl_folder/$installer"

# Check download success
if [ $? -eq 0 ]; then
  echo "Download completed: $dl_folder/$installer"
else
  echo "Failed to download $dl_link"
  exit 1
fi

# Run the installer silently
echo "Running the installer in silent mode..."
"$dl_folder/$installer" /S /CONFIG="$silent_config" /LOG="$log_file" /D="$trgt_folder"

# Check installer success
if [ $? -eq 0 ]; then
  echo "IntelliJ IDEA Ultimate installed successfully."
  echo "Log file: $log_file"
else
  echo "Failed to install IntelliJ IDEA Ultimate."
  exit 1
fi