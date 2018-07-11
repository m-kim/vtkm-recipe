#!/bin/bash

set -e
set -x

# Build dependencies

mkdir build-dir
cd build-dir

cmake -GNinja \
    -DCMAKE_BUILD_TYPE=release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_INSTALL_LIBDIR=$PREFIX/lib \
    -DVTKm_ENABLE_TESTING=OFF \
    -DVTKm_ENABLE_RENDERING=ON \
    -DBUILD_TESTS=OFF \
    ..

ninja install

echo -e '#pragma cling add_library_path("'$PREFIX'/lib")\n#pragma cling load("vtkm_rendering-1.2")\n#pragma cling load("vtkm_cont-1.2")' > $PREFIX/include/vtkm_config_cling.h
echo -e '#pragma cling add_include_path("'$PREFIX'/include/vtkm-1.2/")' >> $PREFIX/include/vtkm_config_cling.h
