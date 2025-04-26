#!/usr/bin/env bash

function register_clang_version {
    local version=$1
    local priority=$2
    local prefix=${3-/usr/bin}

    update-alternatives \
        --install /usr/bin/llvm-config       llvm-config      ${prefix}/llvm-config-${version} ${priority} \
        --slave   /usr/bin/llvm-ar           llvm-ar          ${prefix}/llvm-ar-${version} \
        --slave   /usr/bin/llvm-as           llvm-as          ${prefix}/llvm-as-${version} \
        --slave   /usr/bin/llvm-bcanalyzer   llvm-bcanalyzer  ${prefix}/llvm-bcanalyzer-${version} \
        --slave   /usr/bin/llvm-cov          llvm-cov         ${prefix}/llvm-cov-${version} \
        --slave   /usr/bin/llvm-diff         llvm-diff        ${prefix}/llvm-diff-${version} \
        --slave   /usr/bin/llvm-dis          llvm-dis         ${prefix}/llvm-dis-${version} \
        --slave   /usr/bin/llvm-dwarfdump    llvm-dwarfdump   ${prefix}/llvm-dwarfdump-${version} \
        --slave   /usr/bin/llvm-extract      llvm-extract     ${prefix}/llvm-extract-${version} \
        --slave   /usr/bin/llvm-link         llvm-link        ${prefix}/llvm-link-${version} \
        --slave   /usr/bin/llvm-mc           llvm-mc          ${prefix}/llvm-mc-${version} \
        --slave   /usr/bin/llvm-mcmarkup     llvm-mcmarkup    ${prefix}/llvm-mcmarkup-${version} \
        --slave   /usr/bin/llvm-nm           llvm-nm          ${prefix}/llvm-nm-${version} \
        --slave   /usr/bin/llvm-objdump      llvm-objdump     ${prefix}/llvm-objdump-${version} \
        --slave   /usr/bin/llvm-ranlib       llvm-ranlib      ${prefix}/llvm-ranlib-${version} \
        --slave   /usr/bin/llvm-readobj      llvm-readobj     ${prefix}/llvm-readobj-${version} \
        --slave   /usr/bin/llvm-rtdyld       llvm-rtdyld      ${prefix}/llvm-rtdyld-${version} \
        --slave   /usr/bin/llvm-size         llvm-size        ${prefix}/llvm-size-${version} \
        --slave   /usr/bin/llvm-stress       llvm-stress      ${prefix}/llvm-stress-${version} \
        --slave   /usr/bin/llvm-symbolizer   llvm-symbolizer  ${prefix}/llvm-symbolizer-${version} \
        --slave   /usr/bin/llvm-tblgen       llvm-tblgen      ${prefix}/llvm-tblgen-${version}

    update-alternatives \
        --install /usr/bin/clang                 clang                 ${prefix}/clang-${version} ${priority} \
        --slave   /usr/bin/clang++               clang++               ${prefix}/clang++-${version}  \
        --slave   /usr/bin/asan_symbolize        asan_symbolize        ${prefix}/asan_symbolize-${version} \
        --slave   /usr/bin/c-index-test          c-index-test          ${prefix}/c-index-test-${version} \
        --slave   /usr/bin/clang-check           clang-check           ${prefix}/clang-check-${version} \
        --slave   /usr/bin/clang-cl              clang-cl              ${prefix}/clang-cl-${version} \
        --slave   /usr/bin/clang-cpp             clang-cpp             ${prefix}/clang-cpp-${version} \
        --slave   /usr/bin/clang-format          clang-format          ${prefix}/clang-format-${version} \
        --slave   /usr/bin/clang-format-diff     clang-format-diff     ${prefix}/clang-format-diff-${version} \
        --slave   /usr/bin/clang-import-test     clang-import-test     ${prefix}/clang-import-test-${version} \
        --slave   /usr/bin/clang-include-fixer   clang-include-fixer   ${prefix}/clang-include-fixer-${version} \
        --slave   /usr/bin/clang-offload-bundler clang-offload-bundler ${prefix}/clang-offload-bundler-${version} \
        --slave   /usr/bin/clang-query           clang-query           ${prefix}/clang-query-${version} \
        --slave   /usr/bin/clang-rename          clang-rename          ${prefix}/clang-rename-${version} \
        --slave   /usr/bin/clang-reorder-fields  clang-reorder-fields  ${prefix}/clang-reorder-fields-${version} \
        --slave   /usr/bin/clang-tidy            clang-tidy            ${prefix}/clang-tidy-${version} \
        --slave   /usr/bin/clang-scan-deps       clang-scan-deps       ${prefix}/clang-scan-deps-${version} \
        --slave   /usr/bin/lldb                  lldb                  ${prefix}/lldb-${version} \
        --slave   /usr/bin/lldb-server           lldb-server           ${prefix}/lldb-server-${version}
}

register_clang_version $@