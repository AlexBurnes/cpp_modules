cmake_minimum_required(VERSION 3.28)
project(std_module_example CXX)

set(CMAKE_CXX_SCAN_FOR_MODULES ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

include(degree.cmake)

# Define paralle job pool for ninja
define_parallel_degree(4)

find_package(module-logger CONFIG REQUIRED)
find_package(module-prefix CONFIG REQUIRED)

add_executable(
    example
        src/main.cpp

)

target_link_libraries(
    example
    PRIVATE
        module-logger::module-logger
        module-prefix::module-prefix
)

install(
    TARGETS example
    RUNTIME DESTINATION bin
)
