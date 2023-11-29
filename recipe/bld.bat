md build
cd build
if errorlevel 1 exit 1

cmake %CMAKE_ARGS% ^
      -G "NMake Makefiles" ^
      -DUSE_GMP=OFF ^
      -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
      -DCMAKE_PREFIX_PATH=%PREFIX% ^
      -DCMAKE_INSTALL_PREFIX=%PREFIX% ^
      -DINSTALL_TESTS=ON ^
      "%SRC_DIR%"

if errorlevel 1 exit /b 1

cmake --build . -j %CPU_COUNT% --verbose --config Release
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1

REM Install janus_swi Python package as well
set PIP_OPTS=--no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv

cd ../packages/swipy
if errorlevel 1 exit /b 1
%PYTHON% -m pip install . %PIP_OPTS%
if errorlevel 1 exit /b 1
