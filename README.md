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

# Build

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

Вручную работает, c cmake ошибка, возможно что неправильно собрал gcc-14 и поставил его, нужно через update-alternatives. Пока отложил экперименты.

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

### Install clang-19 with clang-scan-deps

```
sudo apt get install clang-19 clang-tools-19
sudo bash ./update-alternatives-clang.sh 19 1
```

# Conan 

Install conan

```
apt install -y python3 python3-pip
pip3 install conan --break-system-packages
conan profile detect --force
```

Other command to build project with conan see ./build script.

# Working build tools environment

* Cmake 3.28.0
* ninja 1.11.1
* conan 2.16
* clang-19

See build script and Dockerfile how to build project using c++20 modules.
