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

# Workaround: upstream CMakeLists.txt install rules for the shared library,
# the pkg-config file, and the cmake config file resolve to ${CMAKE_BINARY_DIR}/lib
# instead of ${CMAKE_INSTALL_PREFIX}/lib under the current CMake + policy-version
# combination (only the Bindings headers install end up in ${PREFIX} correctly).
# Copy the missing artifacts into the conda prefix explicitly.
mkdir -p "${PREFIX}/lib/pkgconfig" "${PREFIX}/lib/cmake/lib3mf"
if compgen -G "lib/*.dylib" > /dev/null; then
    cp -PR lib/*.dylib "${PREFIX}/lib/"
fi
if compgen -G "lib/*.so*" > /dev/null; then
    cp -PR lib/*.so* "${PREFIX}/lib/"
fi
if [ -f lib/pkgconfig/lib3mf.pc ]; then
    cp lib/pkgconfig/lib3mf.pc "${PREFIX}/lib/pkgconfig/"
fi
if [ -f lib/cmake/lib3mf/lib3mfConfig.cmake ]; then
    cp lib/cmake/lib3mf/lib3mfConfig.cmake "${PREFIX}/lib/cmake/lib3mf/"
fi
