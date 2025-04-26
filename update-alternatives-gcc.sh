#!/usr/bin/env bash
function register_gcc_version {
    local version=${1}
    local priority=$2
    local prefix=${3-/usr/bin}

    update-alternatives \
        --install /usr/bin/gcc          gcc         ${prefix}/gcc-$version $priority \
        --slave   /usr/bin/g++          g++         ${prefix}/g++-$version \
        --slave   /usr/bin/cpp          cpp         ${prefix}/cpp-$version \
        --slave   /usr/bin/gcc-ar       gcc-ar      ${prefix}/gcc-ar-$version \
        --slave   /usr/bin/gcc-nm       gcc-nm      ${prefix}/gcc-nm-$version \
        --slave   /usr/bin/gcc-ranlib   gcc-ranlib  ${prefix}/gcc-ranlib-$version \
        --slave   /usr/bin/gcov         gcov        ${prefix}/gcov-$version \
        --slave   /usr/bin/gcov-dump    gcov-dump   ${prefix}/gcov-dump-$version \
        --slave   /usr/bin/gcov-tool    gcov-tool   ${prefix}/gcov-tool-$version \
        --slave   /usr/bin/lto-dump     lto-dump    ${prefix}/lto-dump-$version
}

register_gcc_version $@