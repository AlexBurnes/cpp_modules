import prefix;
import logger;
#include <iostream>

int main() {

    logger l(std::cout);
    prefix<logger> p(l);
    p.output();

    //if uncomment this compile will fail
    //std::cout << fmt::format("test format main");

    return 0;
}
