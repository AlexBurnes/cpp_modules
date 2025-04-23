# C++20 modules, cmake and compilers supports

## Documenatation

Сmake:
* https://www.kitware.com/import-cmake-the-experiment-is-over/
* https://anarthal.github.io/cppblog/modules3
* https://en.cppreference.com/w/cpp/language/modules

Boost:
* [[https://anarthal.github.io/cppblog/modules|C++20 modules and Boost: an analysis]]
* [[https://anarthal.github.io/cppblog/modules2|C++20 modules and Boost: deep dive]]
* [[https://anarthal.github.io/cppblog/modules3|C++20 modules and Boost: a prototype]]


Сonan:
* https://blog.conan.io/2023/10/17/modules-the-packaging-story.html
* https://github.com/jcar87/cxx-module-packaging
* https://github.com/jcar87/cxx-module-packaging/blob/main/cppcon-talk/modules-the-packaging-and-binary-redistribution-story.pdf тут много информации для понимания BMI 

C++ Reference:
* [[https://en.cppreference.com/w/cpp/language/modules|C++ modules]]


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

# Conan 

Install conan

```
apt install -y python3 python3-pip
pip3 install conan --break-system-packages
conan profile detect --force
```

Other command to build project with conan see ./build script.

