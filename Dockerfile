FROM debian:12.7 as builder

ENV DEBIAN_FRONTEND=noninteractive \
    CONAN_PATH=.conan2 

#gcc-12 g++-12 libstdc++-12-dev \

RUN apt-get update && \
    apt-get -y install \
    git make cmake ninja-build \
    clang-19 clang-tools-19 clang-format-19 libc++-19-dev \
    autoconf automake libtool binutils \
    libdigest-sha-perl libipc-run-perl \
    google-perftools glibc-source libgoogle-perftools-dev \
    cppcheck libev-dev libpcre3-dev \
    gettext flex \
    python3 python3-pip \
    lcov wget unzip

RUN mkdir build &&\
    cd build

WORKDIR build
COPY . . 

RUN git clone -v https://github.com/conan-io/conan.git conan-io &&\
    cd conan-io &&\
    pip3 install -e . --break-system-packages

RUN bash update-alternatives-clang.sh 19 19

RUN CXX=clang++ CC=clang conan profile detect &&\
    conan remote add conan-local http://172.18.1.111:8081/artifactory/api/conan/conan-local &&\
    conan remote add conan-proxy http://172.18.1.111:8081/artifactory/api/conan/conan-proxy-svc &&\
    conan remote disable conancenter

RUN bash build

################################################################################

FROM debian:12.7-slim as runtime

LABEL org.opencontainers.image.author="Aleksey.Ozhigov<AlexBurnes@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/AlexBurnes/cpp_modules.git"

RUN apt-get update && \
    apt-get install -y libgoogle-perftools4

COPY --from=builder /build/bin/ /usr/local/bin/

CMD ["/usr/bin/bash"]

