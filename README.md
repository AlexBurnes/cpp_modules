# C++20 modules, cmake and compilers supports

Experimental project to determine the readiness of build utilities and library packages for building a project using c++20 modules.

Goal: Write header only libraries as conan package library, build this project using that libraries.

## Documenatation

Сmake:

- [import-cmake-the-experiment-is-over](https://www.kitware.com/import-cmake-the-experiment-is-over/)
- [cppblog modules](https://anarthal.github.io/cppblog/modules3)


Boost:

- [C++20 modules and Boost: an analysis](https://anarthal.github.io/cppblog/modules)
- [C++20 modules and Boost: deep dive](https://anarthal.github.io/cppblog/modules2)
- [C++20 modules and Boost: a prototype](https://anarthal.github.io/cppblog/modules3)


Сonan:

- [conan modules the packaging story](https://blog.conan.io/2023/10/17/modules-the-packaging-story.html)
- [cxx module packaging](https://github.com/jcar87/cxx-module-packaging)
- [modules-the-packaging-and-binary-redistribution-story.pdf](https://github.com/jcar87/cxx-module-packaging/blob/main/cppcon-talk/modules-the-packaging-and-binary-redistribution-story.pdf)

C++:

- [C++ modules](https://en.cppreference.com/w/cpp/language/modules]

# Experiments

Require install ninja >=1.11 https://github.com/ninja-build/ninja/releases

## Вручную gcc 13.1

```
g++ -std=c++20 -fmodules-ts foo.cpp main.cpp -o hello.exe -x c++-system-header iostream
```

Note - is not neccessary -x c++-system-header iostream 

## Cmake using GCC 13.1

```
cmake -H. -B.build -GNinja  
```

Не работает с gcc, хотя g++ спрокойно собирает его, ошибка:

```
CMake Error in CMakeLists.txt:
  The target named "hello" has C++ sources that may use modules, but the
  compiler does not provide a way to discover the import graph dependencies.
  See the cmake-cxxmodules(7) manual for details.  Use the
  CMAKE_CXX_SCAN_FOR_MODULES variable to enable or disable scanning.

```

## Cmake using GCC 14.1

Вручную работает, c cmake ошибка, но уже другая, возможно что неправильно собрал gcc-14 и поставил его, нужно через update-alternatives. Пока отложил экперименты.

## Cmake using Clang 19

Сборка с помощью clang, приводит к другой ошибке

```
mkdir build
cd build
CXX=clang++ CC=clang cmake -GNinja ..
ninja -v
```

```
FAILED: CMakeFiles/foo.dir/foo.cpp.o.ddi 
"CMAKE_CXX_COMPILER_CLANG_SCAN_DEPS-NOTFOUND"
```

Поставил clang-scan-deps
```
sudo apt install clang-tools-19
sudo update-alternatives --install /usr/bin/clang-scan-deps clang-scan-deps /usr/bin/clang-scan-deps-19 19
```

После чего собралось.

# Build

## Working build tools environment

* Cmake 3.28.0
* ninja 1.11.1
* conan 2.16
* clang-19

See build script and Dockerfile how to build project using c++20 modules.

## Install required tools

### Clang 19

```
sudo apt install clang-19 lang-tools-19
sudo bash update-alternatives-clang 19 19
sudo bash update-alternatives config clang
```

### Conan 2.16

```
git clone -v https://github.com/conan-io/conan.git conan-io
cd conan-io
pip3 install -e . --break-system-packages
```

## Building project

Run build script

```
bash build
```

Build script:

```
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

# Cmake configure project
cmake -H. -B${BUILD_DIR} -GNinja -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_CC_COMPILER=${CC} \
    -DCMAKE_TOOLCHAIN_FILE=${BUILD_DIR}/build/${BUILD_TYPE}/generators/conan_toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=./

# Build project
cmake --build ${BUILD_DIR}

# Install builded targets
cmake --install ${BUILD_DIR}
```