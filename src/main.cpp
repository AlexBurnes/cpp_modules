import prefix;
import logger;
#include <iostream>
//#include <format>

int main() {
    
    logger l(std::cout);
    prefix<logger> p(l);
    p.output();

    //std::cout << std::format("main using {}", "std::format\n");
    //if uncomment this compile will fail
    //std::cout << fmt::format("main using {} also", "fmt::format\n");

    return 0;
}
