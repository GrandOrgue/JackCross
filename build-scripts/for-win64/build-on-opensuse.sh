#!/bin/bash

mkdir -p build/win64
rm -rf build/win64/*

SRC_DIR=$(readlink -f $(dirname $0)/../../submodules/Jack)
echo SRC_DIR=$SRC_DIR
BUILD_DIR=/home/runner/rpmbuild/BUILD/JackCross

  rm -rf $BUILD_DIR
  mkdir -p `dirname $BUILD_DIR` 
  cp -r $SRC_DIR $BUILD_DIR
    
  RPM_BUILD_ROOT="/home/runner/rpmbuild/BUILDROOT/mingw64-jack-1.9.10.24.g042b6aa-2.925.x86_64"
  export RPM_BUILD_ROOT
  
  PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/lib64/pkgconfig:/usr/share/pkgconfig"
  export PKG_CONFIG_PATH
  
  set -x
  umask 022
  /usr/bin/rm -rf "$RPM_BUILD_ROOT"
  /usr/bin/mkdir -p `dirname "$RPM_BUILD_ROOT"`
  /usr/bin/mkdir "$RPM_BUILD_ROOT"

pushd $BUILD_DIR
PKGCONFIG=x86_64-w64-mingw32-pkg-config CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ CFLAGS="-I/usr/x86_64-w64-mingw32/sys-root/mingw/include/tre/" CXXFLAGS="-I/usr/x86_64-w64-mingw32/sys-root/mingw/include/tre/"  ./waf configure  --dist-target=mingw  --winmme --portaudio --prefix=/
./waf build

(echo prefix=/usr/x86_64-w64-mingw32/sys-root/mingw
 echo 'exec_prefix=${prefix}'
 echo 'libdir=${prefix}/lib'
 echo 'includedir=${prefix}/include'
 echo 'server_libs=-L${libdir} -ljackserver'
 echo
 echo Name: jack
 echo Description: the Jack Audio Connection Kit: a low-latency synchronous callback-based media server
 echo Version: 1.9.10.24.g042b6aa
 echo 'Libs: -L${libdir} -ljack'
 echo 'Cflags: -I${includedir}'
) > build/jack.pc
popd

