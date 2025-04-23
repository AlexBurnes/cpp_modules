cmake_minimum_required(VERSION 3.28)
project(std_module_example CXX)

set(CMAKE_CXX_SCAN_FOR_MODULES ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

# Create a library

add_library(foo)
target_sources(foo
    PUBLIC
        FILE_SET CXX_MODULES FILES
        foo.mpp
)

add_library(logger)
target_sources(
    logger
    PUBLIC
        FILE_SET CXX_MODULES FILES
        logger.mpp
)

add_library(prefix)
target_sources(
    prefix
    PUBLIC
        FILE_SET CXX_MODULES FILES
        prefix.mpp
)

# Create an executable
add_executable(
    hello 
        main.cpp

)

# Link to the library foo
target_link_libraries(
    hello 
    PRIVATE
        foo 
        logger 
        prefix
)
