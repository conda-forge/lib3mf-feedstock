#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./Libraries/libressl
cp $BUILD_PREFIX/share/gnuconfig/config.* ./Libraries/libressl/scripts

set -x

mkdir build
cd build
cmake ${CMAKE_ARGS} \
    -DUSE_INCLUDED_ZLIB=OFF -DUSE_INCLUDED_LIBZIP=OFF -DUSE_INCLUDED_SSL=OFF \
    -DCMAKE_BUILD_TYPE:String=Release \
    -DLIB3MF_TESTS=OFF \
    -GNinja \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    ..

ninja

ninja install
