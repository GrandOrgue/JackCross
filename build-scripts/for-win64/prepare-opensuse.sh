#!/bin/sh

set -e

sudo zypper install -y rpm-build
sudo zypper addrepo http://download.opensuse.org/repositories/windows:mingw:win64/openSUSE_Tumbleweed/windows:mingw:win64.repo
sudo zypper --gpg-auto-import-keys refresh

sudo zypper install -y mingw64-cross-binutils mingw64-cross-gcc \
  mingw64-cross-gcc-c++ mingw64-cross-pkg-config mingw64-filesystem \
  mingw64-libgnurx-devel mingw64-libsamplerate-devel mingw64-portaudio-devel \
  mingw64-libsndfile-devel
