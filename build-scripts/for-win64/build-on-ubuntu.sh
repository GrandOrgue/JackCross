#!/bin/bash

set -e

SRC_DIR=$(readlink -f $(dirname $0)/../..)
echo SRC_DIR=$SRC_DIR

DEBIAN_PKG_NAME=jack-mingw-w64
VERSION=${1:-1.9.19}
BUILD_VERSION=${2:-0.os}

BUILD_DIR=`pwd`/build/win64
mkdir -p $BUILD_DIR
pushd $BUILD_DIR
rm -rf *

cp -r $SRC_DIR/submodules/Jack/* $BUILD_DIR/
    
PKG_CONFIG_PATH="/usr/x86_64-w64-mingw32/lib/pkgconfig"
export PKG_CONFIG_PATH
  
set -x
umask 022

MINGW64_PREFIX=/usr/x86_64-w64-mingw32

CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ ./waf configure  --platform=win32 --winmme --portaudio --prefix=$MINGW64_PREFIX
./waf build

# install
PKG_DIR=`pwd`/${DEBIAN_PKG_NAME}_${VERSION}-${BUILD_VERSION}_all

DESTDIR=${PKG_DIR} ./waf install

mkdir $PKG_DIR/DEBIAN

cat >$PKG_DIR/DEBIAN/control <<EOF
Package: $DEBIAN_PKG_NAME
Version: $VERSION-$BUILD_VERSION
Architecture: all
Maintainer: Oleg Samarin <osamarin68@gmail.com>
Description: This is jack audio connection kit for cross-compiling for for Win64
EOF

dpkg-deb --build --root-owner-group $PKG_DIR

popd

