#!/bin/bash

set -e
set -x

# Build dependencies

mkdir build-dir
cd build-dir

CUDACXX=/usr/local/cuda/bin/nvcc cmake -GNinja \
    -DCMAKE_BUILD_TYPE=release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_INSTALL_LIBDIR=$PREFIX/lib \
    -DVTKm_ENABLE_TESTING=OFF \
    -DVTKm_ENABLE_RENDERING=ON \
    -DVTKm_ENABLE_CUDA=ON \
    -DBUILD_TESTS=OFF \
    ..

ninja install

echo -e '#pragma cling add_library_path("'$PREFIX'/lib")\n#pragma cling load("vtkm_rendering-1.3")\n#pragma cling load("vtkm_cont-1.3")' > $PREFIX/include/vtkm_config_cling.h
echo -e '#pragma cling add_include_path("'$PREFIX'/include/vtkm-1.3/")' >> $PREFIX/include/vtkm_config_cling.h

ln -s $PREFIX/include/vtkm-1.3/vtkm/thirdparty/diy/vtkmdiy $PREFIX/include/vtkm-1.3/
ln -s $PREFIX/include/vtkm-1.3/vtkm/thirdparty/taotuple/vtkmtaotuple $PREFIX/include/vtkm-1.3/
