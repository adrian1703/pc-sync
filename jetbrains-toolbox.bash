#!/usr/bin/env bash
set -e

wget -O ~/downloads/toolbox.tar.gz https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.6.3.43718.tar.gz
cd ~/downloads/
tar -xzf toolbox.tar.gz --one-top-level=toolbox --strip-components=1
rm toolbox.tar.gz
mkdir -p ~/jetbrains/
mv toolbox ~/jetbrains/
