#!/bin/bash

if [[ "$#" != 1 ]]; then
    echo -e "Usage:\t$0 [number of threads]"
    exit 1
fi

COMPILERS=("gcc" "clang")
NTHREADS="$1"

function build_python() {
    CC="$1"
    PREFIX_PATH="$2"
    VERSION="$3"
    EXTRA_ARGS="${@:4}"

    echo "Building ${VERSION} version with ${CC}"
    CC="$CC" ./configure --prefix="$PREFIX_PATH" --enable-optimizations --with-lto=full ${EXTRA_ARGS[@]} 1>/dev/null

    if [[ $? != 0 ]]; then
        echo 1>&2 "Unable to configure ${VERSION} version with ${CC}"
        return 1
    fi

    make -j ${NTHREADS} 1>/dev/null
    if [[ $? != 0 ]]; then
        echo 1>&2 "Unable to build ${VERSION} version with ${CC}"
    else
        make install 1>/dev/null
    fi
    make clean
}

for COMPILER in ${COMPILERS[@]}; do
    BUILD_PATH_BASE="$PWD/build/$COMPILER"
    BUILD_PATH_GIL="$BUILD_PATH_BASE-gil"
    BUILD_PATH_JIT="$BUILD_PATH_BASE-jit"
    BUILD_PATH_NORMAL="$BUILD_PATH_BASE-normal"

    pushd "cpython"

    rm -rf "$BUILD_PATH_GIL"
    mkdir -p "$BUILD_PATH_GIL"
    build_python "$COMPILER" "$BUILD_PATH_GIL" "GIL" --disable-gil

    rm -rf "$BUILD_PATH_JIT"
    mkdir -p "$BUILD_PATH_JIT"
    build_python "$COMPILER" "$BUILD_PATH_JIT" "JIT" --enable-experimental-jit=yes

    rm -rf "$BUILD_PATH_NORMAL"
    mkdir -p "$BUILD_PATH_NORMAL"
    build_python "$COMPILER" "$BUILD_PATH_NORMAL" "NORMAL"

    popd
done
