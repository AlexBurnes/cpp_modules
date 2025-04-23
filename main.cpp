import foo;
import prefix;
import logger;
#include <iostream>

int main() {
    foo f;
    f.hello_world();

    logger l(std::cout);
    prefix<logger> p(l);
    p.output();

    return 0;
}
