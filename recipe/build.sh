#!/bin/bash

set -ex # Abort on error.

mkdir build
cd build

echo "CMAKE_ARGS: ${CMAKE_ARGS} ..."

if "$CC" --version 2>/dev/null | grep -qw gcc; then
    BUILD_TYPE=PGO
else
    BUILD_TYPE=Release
fi

CMAKE_OPTS=
case "$(uname)" in
    Darwin)
	CMAKE_OPTS+=" -DUSE_GMP=OFF -DSWIPL_PACKAGES_BDB=OFF"
	;;
esac

cmake -G "Ninja" \
      ${CMAKE_ARGS} \
      ${CMAKE_OPTS} \
      -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT} \
      -DMACOSX_DEPENDENCIES_FROM=$PREFIX \
      -DSWIPL_PACKAGES_QT=OFF \
      -DINSTALL_TESTS=ON \
      ${SRC_DIR}

cmake --build . -j ${CPU_COUNT} --config $BUILD_TYPE
cmake --build . -j ${CPU_COUNT} --target install

# Install janus_swi Python package as well
PIP_OPTS="--no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv"

(cd ../packages/swipy && $PYTHON -m pip install . $PIP_OPTS)
