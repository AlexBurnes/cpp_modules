#include "logger.hpp"
#include "prefix.hpp"
#include <iostream>
#include <format>

int main() {
    logger l(std::cout);
    prefix<logger> p(l);
    p.output();
    std::cout << std::format("main using {}", "std::format\n");
    //line bellow is compiled but we do not include fmt/core.h directly
    std::cout << fmt::format("main using {} also", "fmt::format\n");
    return 0;
}
