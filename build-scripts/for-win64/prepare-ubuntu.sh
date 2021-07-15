#!/bin/bash

set -e

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  python g++-mingw-w64-x86-64 gcc-mingw-w64-x86-64 pkg-config-mingw-w64-x86-64 binutils wget file

mkdir -p deb
pushd deb

wget \
  http://ppa.launchpad.net/tobydox/mingw-w64/ubuntu/pool/main/libs/libsamplerate-mingw-w64/libsamplerate-mingw-w64_0.1.9-2_all.deb \
  https://github.com/oleg68/Mingw64LibGnuRx/releases/download/2.6.1-1.os/libgnurx-mingw-w64_2.6.1-1.os_all.deb \
  https://launchpad.net/~tobydox/+archive/ubuntu/mingw-w64/+files/portaudio-mingw-w64_19.600-20161030-4_all.deb \
  https://launchpad.net/~tobydox/+archive/ubuntu/mingw-w64/+files/libsndfile-mingw-w64_1.0.28-5_all.deb
  
sudo apt-get install -y --allow-downgrades \
  ./libsamplerate-mingw-w64_0.1.9-2_all.deb \
  ./libgnurx-mingw-w64_2.6.1-1.os_all.deb \
  ./portaudio-mingw-w64_19.600-20161030-4_all.deb \
  ./libsndfile-mingw-w64_1.0.28-5_all.deb

popd

