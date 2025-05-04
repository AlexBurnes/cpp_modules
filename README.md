# C++20 Modules, CMake, and Compiler Support

Experimental project to evaluate the readiness of build utilities and library packages for building a project using C++20 modules.

Goal: Create header-only libraries as Conan package libraries and build this project using those libraries.

## Documentation

### CMake:

- [import-cmake-the-experiment-is-over](https://www.kitware.com/import-cmake-the-experiment-is-over/)
- [cppblog modules](https://anarthal.github.io/cppblog/modules3)

### Boost:

- [C++20 modules and Boost: an analysis](https://anarthal.github.io/cppblog/modules)
- [C++20 modules and Boost: deep dive](https://anarthal.github.io/cppblog/modules2)
- [C++20 modules and Boost: a prototype](https://anarthal.github.io/cppblog/modules3)

### Conan:

- [conan modules the packaging story](https://blog.conan.io/2023/10/17/modules-the-packaging-story.html)
- [cxx module packaging](https://github.com/jcar87/cxx-module-packaging)
- [modules-the-packaging-and-binary-redistribution-story.pdf](https://github.com/jcar87/cxx-module-packaging/blob/main/cppcon-talk/modules-the-packaging-and-binary-redistribution-story.pdf)

### C++:

- [C++ modules](https://en.cppreference.com/w/cpp/language/modules)

# Experiments

Requires installation of ninja >=1.11: https://github.com/ninja-build/ninja/releases

## Manual build with GCC 13.1

```bash
g++ -std=c++20 -fmodules-ts foo.cpp main.cpp -o hello.exe -x c++-system-header iostream
```

## CMake with GCC 13.1

```bash
cmake -H. -B.build -GNinja
```

Doesn't work with GCC, although g++ compiles it without issues. Error:

```
CMake Error in CMakeLists.txt:
  The target named "hello" has C++ sources that may use modules, but the
  compiler does not provide a way to discover the import graph dependencies.
  See the cmake-cxxmodules(7) manual for details.  Use the
  CMAKE_CXX_SCAN_FOR_MODULES variable to enable or disable scanning.

```

## CMake with GCC 14.1
Manual build works, but CMake produces a different error. This might be due to incorrect GCC-14 installation or configuration via update-alternatives. 
Experiments are postponed for now.

## CMake with Clang 19

Building with Clang results in a different error:

```bash
mkdir build
cd build
CXX=clang++ CC=clang cmake -GNinja ..
ninja -v
```

Error:

```
FAILED: CMakeFiles/foo.dir/foo.cpp.o.ddi 
"CMAKE_CXX_COMPILER_CLANG_SCAN_DEPS-NOTFOUND"

```

Installed clang-scan-deps:

```bash
sudo apt install clang-tools-19
sudo update-alternatives --install /usr/bin/clang-scan-deps clang-scan-deps /usr/bin/clang-scan-deps-19 19
```

After installation, the build succeeds.

# Build

Working build tools environment:

* CMake 3.28.0
* Ninja 1.11.1
* Conan 2.16
* Clang-19

See the build script and Dockerfile for instructions on building the project using C++20 modules.

Build tested in OS: ubuntu 22.04, ubuntu 24.04.2

## Install required tools

### Clang 19

```bash
sudo apt install clang-19 lang-tools-19
sudo bash update-alternatives-clang 19 19
sudo bash update-alternatives config clang
```

### Conan 2.16

```bash
git clone -v https://github.com/conan-io/conan.git conan-io
cd conan-io
pip3 install -e . --break-system-packages

```

## Building the project

Run the build script:

```bash
bash build
```

Build script:

```bash
#!/usr/bin/env bash
set -x 
set -o errexit
set -o nounset

PWD=$(pwd)
trap cleanup_ SIGINT SIGTERM EXIT
cleanup_() {
    rc=$?
    trap - SIGINT SIGTERM EXIT
    set +e
    [[ "$(type -t cleanup)" == "function" ]] && cleanup
    cd "${PWD}"
    exit $rc
}

BUILD_DIR=.build
BUILD_TYPE=Release

# Define compiler 
CXX=clang++
CC=clang
export CXX CC

# Detect and configure conan profile for clang
CONAN_PROFILE=${CC}_${BUILD_TYPE}
conan profile detect --name ${CONAN_PROFILE} -f
sed -i -e "s/compiler.cppstd=gnu17/compiler.cppstd=gnu20/g" ~/.conan2/profiles/${CONAN_PROFILE}
cat << EOF >> ~/.conan2/profiles/${CONAN_PROFILE}
[conf]
tools.cmake.cmaketoolchain:generator=Ninja
EOF

# Install and build conan libraries and tools defined in conantfile.txt
conan install . -of ${BUILD_DIR} -pr:h ${CONAN_PROFILE} -pr:b ${CONAN_PROFILE} --build missing
source ${BUILD_DIR}/build/${BUILD_TYPE}/generators/conanbuild.sh

# CMake configure project
cmake -H. -B${BUILD_DIR} -GNinja -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_CC_COMPILER=${CC} \
    -DCMAKE_TOOLCHAIN_FILE=${BUILD_DIR}/build/${BUILD_TYPE}/generators/conan_toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=./

# Build project
cmake --build ${BUILD_DIR}

# Install built targets
cmake --install ${BUILD_DIR}
```

# History of changes

You can see the evolution of changes from templated header-only libraries to module libraries in the project branches:
* header_only - class libraries in .hpp files
* library_modules - intermediate version with monolithic project containing C++20 modules in .mpp files
* master - C++20 modules as Conan package libraries; this project installs and uses them. Modules are in separate projects:
    * Logger module: https://github.com/AlexBurnes/module_logger
    * Prefix module: https://github.com/AlexBurnes/module_prefix

# Build in docker container



Build: 

    docker-build

Run:

    docker-run

Note: Not yet complite, there is a trouble to build project and modules with clang and std::format. 
Error: fatal error: 'format' file not found

