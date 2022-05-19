mkdir build && cd build

cmake ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_LIBDIR=%LIBRARY_LIB% ^
    -DLIB3MF_TESTS=OFF ^
    -DCMAKE_BUILD_TYPE:String=Release ^
    -G "NMake Makefiles" ^
    ..

cmake --build . --target install
if errorlevel 1 exit 1
