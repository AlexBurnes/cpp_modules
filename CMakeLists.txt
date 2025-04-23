cmake_minimum_required(VERSION 3.28)
project(std_module_example CXX)

set(CMAKE_CXX_SCAN_FOR_MODULES OFF)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

find_package(fmt REQUIRED)

add_library(prefix INTERFACE IMPORTED)
set_property(
    TARGET prefix
    APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    fmt::fmt
)

add_executable(
    example
        main.cpp
)

target_link_libraries(
    example
        prefix
)
