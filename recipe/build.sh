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
	CMAKE_OPTS+=" -DUSE_GMP=OFF"
	CMAKE_OPTS+=" -DSWIPL_PACKAGES_BDB=OFF"
	CMAKE_OPTS+=" -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT}"
	CMAKE_OPTS+=" -DMACOSX_DEPENDENCIES_FROM=$PREFIX"
	;;
esac

cmake -G "Ninja" \
      ${CMAKE_ARGS} \
      ${CMAKE_OPTS} \
      -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DSWIPL_INSTALL_IN_LIB=ON \
      -DSWIPL_INSTALL_IN_SHARE=ON \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DSWIPL_PACKAGES_QT=OFF \
      -DINSTALL_TESTS=ON \
      ${SRC_DIR}

# Build Prolog and packages
cmake --build . -j ${CPU_COUNT} --config $BUILD_TYPE
# Build Python janus_swi package
(cd ../packages/swipy && $PYTHON -m build --no-isolation .)

# Install (disabled as we install using the outputs section)
#cmake --build . -j ${CPU_COUNT} --target install

