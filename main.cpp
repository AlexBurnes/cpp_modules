import prefix;
import logger;
#include <iostream>

int main() {

    logger l(std::cout);
    prefix<logger> p(l);
    p.output();

    return 0;
}
