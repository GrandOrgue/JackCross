#!/bin/bash

set -e

SRC_DIR=$(readlink -f $(dirname $0)/../..)
echo SRC_DIR=$SRC_DIR

DEBIAN_PKG_NAME=jack-mingw-w64
VERSION=${1:-1.9.10}
BUILD_VERSION=${2:-0.os}

BUILD_DIR=`pwd`/build/win64
mkdir -p $BUILD_DIR
rm -rf $BUILD_DIR/*

cp -r $SRC_DIR/submodules/Jack/* $BUILD_DIR/
    
PKG_CONFIG_PATH="/usr/x86_64-w64-mingw32/lib/pkgconfig"
export PKG_CONFIG_PATH
  
set -x
umask 022

pushd $BUILD_DIR
CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ ./waf configure  --dist-target=mingw  --winmme --portaudio --prefix=/
./waf build

MINGW64_PREFIX=/usr/x86_64-w64-mingw32

(echo prefix=$MINGW64_PREFIX
 echo 'exec_prefix=${prefix}'
 echo 'libdir=${prefix}/lib'
 echo 'includedir=${prefix}/include'
 echo 'server_libs=-L${libdir} -ljackserver'
 echo
 echo Name: jack
 echo Description: the Jack Audio Connection Kit: a low-latency synchronous callback-based media server
 echo Version: $VERSION-$BUILD_VERSION
 echo 'Libs: -L${libdir} -ljack'
 echo 'Cflags: -I${includedir}'
) > build/jack.pc

# install
PKG_DIR=`pwd`/${DEBIAN_PKG_NAME}_${VERSION}-${BUILD_VERSION}_all

DESTDIR=${PKG_DIR}${MINGW64_PREFIX} ./waf install
mkdir -p ${PKG_DIR}${MINGW64_PREFIX}/lib/jack
mv ${PKG_DIR}${MINGW64_PREFIX}/lib/*.a ${PKG_DIR}${MINGW64_PREFIX}/lib/jack/
mv ${PKG_DIR}${MINGW64_PREFIX}/lib/jack/libj* ${PKG_DIR}${MINGW64_PREFIX}/lib/

mkdir $PKG_DIR/DEBIAN

cat >$PKG_DIR/DEBIAN/control <<EOF
Package: $DEBIAN_PKG_NAME
Version: $VERSION
Revision: $BUILD_VERSION
Architecture: all
Maintainer: Oleg Samarin <osamarin68@gmail.com>
Description: This is jack audio connection kit for cross-compiling for for Win64
EOF

dpkg-deb --build --root-owner-group $PKG_DIR

popd

