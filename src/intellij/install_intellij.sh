#!/bin/bash

installer="ideaIU-latest.exe"
dl_link="https://download.jetbrains.com/idea/ideaIU-latest.exe"
dl_folder="$TMP"
trgt_folder="$IDES/jetbrains" # somehow this is lowercase dont ask me why

echo "Installing Intellij ..."
echo "installer: $installer"
echo "download link: $dl_link"
echo "download folder: $dl_folder"
echo "target folder: $trgt_folder"